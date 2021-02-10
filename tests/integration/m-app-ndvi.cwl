$graph:
- class: Workflow
  doc: Main stage manager
  id: stage-manager
  inputs:
    ADES_STAGEOUT_AWS_ACCESS_KEY_ID:
      type: string?
    ADES_STAGEOUT_AWS_PROFILE:
      type: string?
    ADES_STAGEOUT_AWS_SECRET_ACCESS_KEY:
      type: string?
    ADES_STAGEOUT_AWS_SERVICEURL:
      type: string?
    ADES_STAGEOUT_OUTPUT:
      type: string?
    aws_profile:
      type: string?
    aws_profiles_location:
      type: File?
    aws_service_url:
      type: string?
    input_reference:
      doc: Input product reference
      id: input_reference
      label: Input product reference
      type: string[]
  label: theStage
  outputs:
    wf_outputs:
      outputSource:
      - node_stage_out/wf_outputs_out
      type:
        items: Directory
        type: array
  requirements:
    ScatterFeatureRequirement: {}
    SubworkflowFeatureRequirement: {}
  steps:
    node_stage_in:
      in:
        aws_profile: aws_profile
        aws_profiles_location: aws_profiles_location
        aws_service_url: aws_service_url
        input_reference: input_reference
      out:
      - input_reference_out
      run:
        arguments:
        - copy
        - --harvest
        - -v
        - -rel
        - -r
        - '4'
        - -o
        - ./
        baseCommand: Stars
        class: CommandLineTool
        cwlVersion: v1.0
        doc: Run Stars for staging data
        hints:
          DockerRequirement:
            dockerPull: terradue/stars-t2:latest
        id: stars
        inputs:
          aws_profile:
            type: string?
          aws_profiles_location:
            type: File?
          aws_service_url:
            type: string?
          input_reference:
            inputBinding:
              position: 2
            type: string
        outputs:
          input_reference_out:
            outputBinding:
              glob: .
            type: Directory
        requirements:
          EnvVarRequirement:
            envDef:
              PATH: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
          ResourceRequirement: {}
      scatter: input_reference
      scatterMethod: dotproduct
    node_stage_out:
      in:
        ADES_STAGEOUT_AWS_ACCESS_KEY_ID: ADES_STAGEOUT_AWS_ACCESS_KEY_ID
        ADES_STAGEOUT_AWS_PROFILE: ADES_STAGEOUT_AWS_PROFILE
        ADES_STAGEOUT_AWS_SECRET_ACCESS_KEY: ADES_STAGEOUT_AWS_SECRET_ACCESS_KEY
        ADES_STAGEOUT_AWS_SERVICEURL: ADES_STAGEOUT_AWS_SERVICEURL
        ADES_STAGEOUT_OUTPUT: ADES_STAGEOUT_OUTPUT
        aws_profiles_location: aws_profiles_location
        wf_outputs: on_stage/wf_outputs
      out:
      - wf_outputs_out
      run:
        arguments:
        - copy
        - -v
        - -r
        - '4'
        baseCommand: Stars
        class: CommandLineTool
        cwlVersion: v1.0
        doc: Run Stars for staging data
        hints:
          DockerRequirement:
            dockerPull: terradue/stars:latest
        id: stars
        inputs:
          ADES_STAGEOUT_AWS_ACCESS_KEY_ID:
            type: string?
          ADES_STAGEOUT_AWS_PROFILE:
            type: string?
          ADES_STAGEOUT_AWS_SECRET_ACCESS_KEY:
            type: string?
          ADES_STAGEOUT_AWS_SERVICEURL:
            type: string?
          ADES_STAGEOUT_OUTPUT:
            inputBinding:
              position: 5
              prefix: -o
            type: string?
          aws_profiles_location:
            type: File?
          wf_outputs:
            inputBinding:
              position: 6
            type: Directory[]
        outputs:
          wf_outputs_out:
            outputBinding:
              glob: .
            type: Directory[]
        requirements:
          EnvVarRequirement:
            envDef:
              AWS_ACCESS_KEY_ID: $(inputs.ADES_STAGEOUT_AWS_ACCESS_KEY_ID)
              AWS_SECRET_ACCESS_KEY: $(inputs.ADES_STAGEOUT_AWS_SECRET_ACCESS_KEY)
              AWS__Profile: $(inputs.ADES_STAGEOUT_AWS_PROFILE)
              AWS__ServiceURL: $(inputs.ADES_STAGEOUT_AWS_SERVICEURL)
              PATH: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
          ResourceRequirement: {}
    on_stage:
      in:
        input_reference: node_stage_in/input_reference_out
      out:
      - wf_outputs
      run: '#ndvi'
- arguments:
  - --s-expression
  - (/ (- nir red) (+ nir red))
  - --cbn
  - ndvi
  baseCommand: s-expression
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
