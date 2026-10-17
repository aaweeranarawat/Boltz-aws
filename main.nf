nextflow.enable.dsl=2

params.input_yaml      = null
params.msa_dir         = null
params.boltz_image     = null   // e.g. <acct>.dkr.ecr.<region>.amazonaws.com/boltz:latest
params.use_msa_server  = false  // needs internet access; off by default for HealthOmics

if (!params.input_yaml)  error "Missing required parameter: input_yaml"
if (!params.boltz_image) error "Missing required parameter: boltz_image"

process BOLTZ_PREDICT {
    container params.boltz_image
    cpus 8
    memory '60 GB'
    accelerator 1, type: 'nvidia-tesla-a10g'
    publishDir "/mnt/workflow/pubdir", mode: 'copy'

    input:
    path input_yaml
    path msa_dir      // staged under its own name; reference it from the YAML's msa paths

    output:
    path "boltz_out"

    script:
    def msa_flag = params.use_msa_server ? '--use_msa_server' : ''
    """
    boltz predict ${input_yaml} --out_dir boltz_out --cache /opt/boltz_cache ${msa_flag}
    """
}

workflow {
    // An empty list stages nothing when msa_dir is not supplied
    msa = params.msa_dir ? file(params.msa_dir) : []
    BOLTZ_PREDICT(file(params.input_yaml), msa)
}
