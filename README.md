# Demo application - Normalized Hotspot Indices

Simple demo application 

## Development 

### Create the conda environment

```bash
cd app-nhi
```

Create the Python environment with `mamba` (faster) or `conda` (slower):

```bash
mamba env create -f environment.yml
```

Activate the Python environment with:

```bash
conda activate env_app_snuggs
```

### Build the Python project

To build and install the project locally:

```
python setup.py install
```

Test the CLI with:

```bash
nhi --help
```

That returns:

```console
$ s-expression --help
Usage: s-expression [OPTIONS]

  Applies s expressions to EO acquisitions

Options:
  -i, --input_reference PATH  Input product reference  [required]
  -s, --s-expression TEXT     s expression  [required]
  -b, --cbn TEXT              Common band name  [required]
  --help                      Show this message and exit.
```

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