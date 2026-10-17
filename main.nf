nextflow.enable.dsl=2

params.input_yaml  = null
params.msa_dir     = null
params.boltz_image = "289138883132.dkr.ecr.us-west-2.amazonaws.com/boltz:latest"

process BOLTZ_PREDICT {
    container params.boltz_image
    cpus 8
    memory '60 GB'
    accelerator 1
    publishDir "/mnt/workflow/pubdir", mode: 'copy'

    input:
    path input_yaml
    path msa_dir

    output:
    path "boltz_out"

    script:
    """
    boltz predict ${input_yaml} --out_dir boltz_out --cache /opt/boltz_cache
    """
}

workflow {
    msa = params.msa_dir ? file(params.msa_dir) : file('NO_FILE')
    BOLTZ_PREDICT(file(params.input_yaml), msa)
}
