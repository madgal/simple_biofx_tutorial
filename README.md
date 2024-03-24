# simple_biofx_tutorial
This repo contains a simple pipeline as an example of my approach to bioinformatics

## Dependencies
- nextflow version 23.10.1 (https://www.nextflow.io/docs/latest/getstarted.html)
  - sdkman installation
  - Java Corretto 17 (sdk install java 17.0.6-amzn)
- Docker: 
  - the "simple_biofx_docker" is used when running the pipeline
    - run the following command 
    - docker build . -t "simple_biofx_docker"


## Example 

Execute the pipeline using nextflow

E.g., nextflow run main.nf -profile local