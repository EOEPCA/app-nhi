# Demo application - Normalized Hotspot Indices

Simple demo application 

## Tests

```console
cd tests/integration
sh run.sh https://app-packages.s3.fr-par.scw.cloud/nhi/app-nhi.dev.0.0.2.cwl params-nhi.yml 
```

## Build

This repo includes a Jenkinsfile that:

- builds the docker image 
- dumps the application package (CWL)
- uploads the application package to S3 

## Getting the application package

Use the URL https://app-packages.s3.fr-par.scw.cloud/nhi/app-nhi.dev.0.0.2.cwl (update the version if needed)