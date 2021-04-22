
curl $1 -o temp.cwl

cwl-wrapper \
    --stagein stagein-stars.cwl_ \
    --stageout stageout-stars.cwl_ \
    temp.cwl > m-temp.cwl

cwltool --outdir \
        test-execution \
        m-temp.cwl#stage-manager \
        $2

rm -f \
    m-temp.cwl \
    temp.cwl