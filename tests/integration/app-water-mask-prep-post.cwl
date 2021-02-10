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
  doc: Water mask based on NDWI threshold, pre and post
  id: water-mask-pre-post
  inputs:
    input_reference_pre:
      doc: Pre-event product reference
      label: Pre-event product reference
      type: Directory
    input_reference_post:
      doc: Post-event product reference
      label: Post-event product reference
      type: Directory
  label: Water mask based on NDWI threshold, pre and post
  requirements:
    MultipleInputFeatureRequirement: {} 
  outputs:
  - id: wf_outputs
    outputSource:
    - step_1/results
    - step_2/results
    type: Directory[]
  steps:
    step_1:
      in:
        input_reference: input_reference_pre
      out:
      - results
      run: '#clt'
    step_2:
      in:
        input_reference: input_reference_post
      out:
      - results
      run: '#clt' 
$namespaces:
  s: https://schema.org/
cwlVersion: v1.0
schemas:
- http://schema.org/version/9.0/schemaorg-current-http.rdf

