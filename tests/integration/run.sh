cwl-wrapper \
    --stagein stagein-stars.cwl_ \
    --stageout stageout-stars.cwl_ \
    $1 > m-$1

cwltool --outdir test-execution m-$1#stage-manager $2

rm -f m-$1