#!/bin/bash
set -euo pipefail
REGION=${REGION:-us-east-1}
REPO=${REPO:-boltz}
ACCT=$(aws sts get-caller-identity --query Account --output text)
URI=$ACCT.dkr.ecr.$REGION.amazonaws.com/$REPO

aws ecr describe-repositories --repository-names $REPO --region $REGION >/dev/null 2>&1 || \
  aws ecr create-repository --repository-name $REPO --region $REGION

# Allow AWS HealthOmics to pull the image
aws ecr set-repository-policy --repository-name $REPO --region $REGION --policy-text '{
  "Version": "2012-10-17",
  "Statement": [{
    "Sid": "OmicsAccess",
    "Effect": "Allow",
    "Principal": {"Service": "omics.amazonaws.com"},
    "Action": ["ecr:GetDownloadUrlForLayer", "ecr:BatchGetImage", "ecr:BatchCheckLayerAvailability"]
  }]
}'

aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCT.dkr.ecr.$REGION.amazonaws.com
docker build --platform linux/amd64 -t $REPO .
docker tag $REPO:latest $URI:latest
docker push $URI:latest
echo "Pushed $URI:latest"
