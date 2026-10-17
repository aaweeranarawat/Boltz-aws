# Boltz-aws

Run [Boltz-2](https://github.com/jwohlwend/boltz) as a Nextflow workflow on AWS HealthOmics.

1. `./build_and_push.sh` builds the GPU image (weights baked in) and pushes it to ECR, with a policy that lets HealthOmics pull it.
2. Create the workflow from `main.nf` and `parameter-template.json`.
3. Run with `input_yaml`, `boltz_image`, and optionally `msa_dir`.

HealthOmics tasks have no internet by default, so for protein inputs either supply precomputed MSAs
(`msa_dir`, referenced from the YAML) or set `msa: empty` in the YAML. `use_msa_server=true` needs network access.
