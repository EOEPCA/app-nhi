def dockerRegistry = 'registry.hub.docker.com/eoepcaci'
def bucket = 'e0a5ea9bd7614c97a072fa5b3b8165ea:rm-user-usera'
def workspace = 'rm-user-usera'

pipeline {
    agent any
    environment {
        def dockerPartialTag = sh returnStdout: true, script: "cat ./setup.cfg | grep name | sed -e \"s/.*=//g\" -e \"s/['| ]//g\" | tr -d '\n'"
        def dockerNewVersion = sh returnStdout: true, script: "cat ./setup.cfg | grep version | sed -e \"s/.*=//g\" -e \"s/['| ]//g\"  | tr -d '\n'"
        def dockerTag = "${dockerRegistry}/${dockerPartialTag}"
        def mType=getTypeOfVersion(env.BRANCH_NAME)
        def appType=getTypeOfPackage(env.BRANCH_NAME)
    }
    stages {
        stage('Build & Publish Docker') {
            steps {
                script {

                    def app = docker.build("${dockerTag}:${mType}${dockerNewVersion}", "-f .docker/Dockerfile .")
  
                    docker.withRegistry("https://${dockerRegistry}", 'dockerhub-eoepcaci') {
                     app.push("${mType}${dockerNewVersion}")
                      app.push("${mType}latest")
                    }
                }
            }
        }

        stage('Publish Artifact') {
            agent any
            steps {
                script {
                    echo 'Deploying application package artifacts'

                    app='nhi'

                    sh "docker run --rm ${dockerTag}:${mType}${dockerNewVersion} ${app} -i dummy -t dummy --docker ${dockerTag}:${mType}${dockerNewVersion} --dump cwl --metadata version=${dockerNewVersion} --scatter input_reference > app-${app}${appType}${dockerNewVersion}.cwl"

                    sh "cat app-${app}${appType}${dockerNewVersion}.cwl"

                  
                    withAWS(endpointUrl: 'https://s3.fr-par.scw.cloud', credentials:'scaleway-s3') {
                        s3Upload(file: "app-${app}${appType}${dockerNewVersion}.cwl", bucket:"app-packages", path: "${app}/app-${app}${appType}${dockerNewVersion}.cwl");
                    }

                    withAWS(endpointUrl: 'cf2.cloudferro.com:8080', credentials:'workspace-usera') {
                        s3Upload(file: "app-${app}${appType}${dockerNewVersion}.cwl", bucket:"${bucket}", path: "application-package/${app}/app-${app}${appType}${dockerNewVersion}.cwl");
                    }


                    def response = httpRequest(url="https://workspace-api.185.52.193.87.nip.io/workspace/workspace/register", httpMode='POST', requestBody="{\"type\": \"cwl\", \"url\": \"s3://${bucket}/application-package/${app}/app-${app}${appType}${dockerNewVersion}.cwl\"}" )

                    println("Status: "+response.status)
                    println("Content: "+response.content)

                }
            }  
        }
    }
}

def getTypeOfVersion(branchName) {
  
  def matcher = (env.BRANCH_NAME =~ /master/)
  if (matcher.matches())
    return ""
  
  return "dev"
}

def getTypeOfPackage(branchName) {
  
  def matcher = (env.BRANCH_NAME =~ /master/)
  if (matcher.matches())
    return ""
  
  return ".dev."
}