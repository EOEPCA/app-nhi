$graph:
- baseCommand: s-expression
  arguments: ['--s-expression', '(where (>= (/ (- green nir) (+ green nir)) 0.3) 1 0)', '--cbn', 'water-mask'] 
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
  #stderr: std.err
  #stdout: std.out
- class: Workflow
  doc: Water mask based on NDWI threshold
  id: water-mask
  inputs:
    input_reference:
      doc: Input product reference
      label: Input product reference
      type: Directory
  label: Water mask based on NDWI threshold
  outputs:
  - id: wf_outputs
    outputSource:
    - step_1/results
    type: Directory
  steps:
    step_1:
      in:
        input_reference: input_reference
      out:
      - results
      run: '#clt'
$namespaces:
  s: https://schema.org/
cwlVersion: v1.0
schemas:
- http://schema.org/version/9.0/schemaorg-current-http.rdf

