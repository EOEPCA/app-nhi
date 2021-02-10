$graph:
- baseCommand: s-expression
  arguments: ['--s-expression', '(/ (- nir red) (+ nir red))', '--cbn', 'ndvi']
  class: CommandLineTool
  hints:
    DockerRequirement:
      dockerPull: s-express:latest
  id: clt
  inputs:
    input_reference:
      inputBinding:
        position: 1
        prefix: --input_reference
      type: Directory
  outputs:
    results:
      outputBinding:
        glob: .
      type: Directory
  requirements:
    EnvVarRequirement:
      envDef:
        PATH: /srv/conda/envs/env_app_snuggs/bin:/srv/conda/envs/env_app_snuggs/bin:/srv/conda/bin:/srv/conda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    ResourceRequirement: {}
  stderr: std.err
  stdout: std.out
- class: Workflow
  doc: NDVI spectral index
  id: ndvi
  inputs:
    input_reference:
      doc: Input product reference
      label: Input product reference
      type: Directory[]
  label: NDVI spectral index
  outputs:
  - id: wf_outputs
    outputSource:
    - step_1/results
    type:
      items: Directory
      type: array
  requirements:
  - class: ScatterFeatureRequirement
  steps:
    step_1:
      in:
        input_reference: input_reference
      out:
      - results
      run: '#clt'
      scatter: input_reference
      scatterMethod: dotproduct
$namespaces:
  s: https://schema.org/
cwlVersion: v1.0
schemas:
- http://schema.org/version/9.0/schemaorg-current-http.rdf

