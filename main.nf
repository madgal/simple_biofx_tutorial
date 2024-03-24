#!/bin/env nextflow
nextflow.enable.dsl=2

/*
    This is mean as an example to show a simple
    bioinformatics pipeline
*/
process qc_input{
    input:
        path(dirname)
    output:
        path("qc_report.txt"), emit: report
    publishDir params.outdir, mode: "copy"
    script:
    """
        echo "QC model output:" >> qc_report.txt
        if [ -d "$dirname" ]; then
            echo "$dirname exists and is a directory." >> qc_report.txt
        else
            echo "$dirname does not exist, or is not a directory." >> qc_report.txt
        fi
    """
}
process fastq_downsample{
    input:
        tuple val(sample_id), path(read1), path(read2)
        val(sample_rate)
    output:
        tuple val(sample_id), path("${read1}.downsampled.fastq.gz"), path("${read2}.downsampled.fastq.gz"), emit: downsampled_fastqs
    publishDir params.outdir, mode: "copy"
    script:
    """
        \$bbmap_reformat in=${read1} in2=${read2} \
            out=${read1}.downsampled.fastq.gz \
            out2=${read2}.downsampled.fastq.gz \
            samplerate=${sample_rate} \
            sampleseed=32
    """

}

workflow{
    sw_version="1.0.0"

    log.info " This is the example pipeline "
    log.info " sw_version: ${sw_version}"

    //First read in all of the pipeline parameters
    fastq_location = Channel.fromPath(params.fastq_dir)

    //Complete qc on input as needed (ensure the user didn't input erroneous information)
    qc_input(fastq_location)


    // Create the channels needed for the processes
    fastqs = Channel.fromFilePairs("${params.fastq_dir}/*{1,2}.fastq")
                .view()
                .map{ meta, it -> [meta, it[0], it[1]]}
                .view()

    downsample_fraction = params.downsample_fraction
    log.info "The rate of downsampling is set to ${downsample_fraction}"
    // Downsample the fastqs
    fastq_downsample(fastqs,downsample_fraction)

    // QC the fastqs

    // alignment

    // variant calling
}

workflow.onComplete = {
    if(workflow.success){
        log.info "The pipeline has completed successfully"
        //sendmail to stakeholder that pipeline has completed
    }
}

workflow.onError = {
    log.info "Error: something when wrong"
    //sendMail to developer that pipeline failed
}