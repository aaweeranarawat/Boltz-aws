#!/bin/bash
set -e
REGION=us-east-1
ACCT=289138883132
REPO=boltz
aws ecr create-repository --repository-name $REPO --region $REGION || true
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCT.dkr.ecr.$REGION.amazonaws.com
docker build --platform linux/amd64 -t $REPO .
docker tag $REPO:latest $ACCT.dkr.ecr.$REGION.amazonaws.com/$REPO:latest
docker push $ACCT.dkr.ecr.$REGION.amazonaws.com/$REPO:latest
