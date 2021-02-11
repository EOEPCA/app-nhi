# s-expression for EO product band math

Snuggs

## Development 

```bash
cd app-s-expression
```

Create the Python environment with `mamba` (faster) or `conda` (slower):

```bash
mamba env create -f environment.yml
```

Activate the Python environment with:

```bash
conda activate  env_app_snuggs
```

## Build the Python project

To build and install the project locally:

```
python setup.py install
```

Test the CLI with:

```bash
s-expression --help
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

## Building the docker image

Build the docker image with:

```bash
docker build -t s-expression:0.1  -f .docker/Dockerfile .
```

Test the CLI with:

```bash
docker run --rm -it s-expression:0.1 s-expression --help
```

## Usage

There are three application packages:

### app-s-expression.cwl

This is the configuration exposing all the parameters:

- **input_reference** This is the input product reference 

- **s-expression** This is the s-expression (see below what are s expressions)

- **cbn** This is the common band name for the generated band 

About the s-expressions:

In computer programming, S-expressions (or symbolic expressions, abbreviated as sexprs) are a notation for nested list (tree-structured) data, invented for and popularized by the programming language Lisp.

Here we use s-expression to express band combination operations on the EO product assets accessed using the common band names.

For instance, to do the normalized difference for the red and nir bands, this is expressed as:

```yaml
(/ (- nir red) (+ nir red))
```

Let's break down the components of this s-expression:

- `(- nir red)` is the difference between the `nir` and `red` assets read as array. This is equivalent to `nir - red`

- `(+ nir red)` is the sum of `nir` and `red` assets read as array. This is equivalent to `nir + red`

- The difference  `(- nir red)` is divided by `(+ nir red)` to provide the NDVI with `(/ (- nir red) (+ nir red))`

So to do the NDVI, the app-s-expression.cwl CWL document can be invoked with:

```yaml
input_reference: {class: Directory, path: '/workspace/stage-in/1_o28lv8'}
s_expression: '(/ (- nir red) (+ nir red))'
cbn: 'ndvi'
```

### app-water-mask.cwl

The app-water-mask.cwl exposes a single parameter, **input_reference** and defines the arguments **s-expression** and **cbn** in the CWL document:

- **s-expression** `(where (>= (/ (- green nir) (+ green nir)) 0.3) 1 0)`

- **cbn** `water-mask`

### app-ndvi.cwl

The app-ndvi.cwl exposes a single parameter, **input_reference** and defines the arguments **s-expression** and **cbn** in the CWL document:

- **s-expression** `(/ (- nir red) (+ nir red))`

- **cbn** `ndvi`