# app-snuggs - Snuggs

Snuggs

## Development 

```bash
cd app_snuggs
```

```bash
conda env create -f environment.yml
```

Activate the conda environment

```bash
conda activate  env_app_snuggs
```

To build and install the project locally:

```
python setup.py install
```

Test the CLI with:

```bash
app-snuggs --help
```

## Building the docker image

Build the docker image with:

```bash
docker build -t app_snuggs:0.1  -f .docker/Dockerfile .
```

or for pushing to the `docker.terradue.com` docker repository:

```bash
docker build -t docker.terradue.com/app_snuggs:0.1  -f .docker/Dockerfile .
```

Test the CLI with:

```bash
docker run --rm -it app_snuggs:0.1 app-snuggs --help
```

or 

```bash
docker run --rm -it docker.terradue.com/app_snuggs:0.1 app-snuggs --help
```

## Creating the CWL

Check the examples provided in the `cwl-examples` folder and adapt one to the application requirements

## Setting up the git repository

```bash
git init
git remote add origin <git repository URL>
```

Once you're ready to add, commit and push, do:

```bash
git add -A
git commit -m 'first commit'
git push -u origin master
```
