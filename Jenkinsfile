def dockerRegistry = 'registry.hub.docker.com/eoepcaci'

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

                    sh "docker run --rm ${dockerTag}:${mType}${dockerNewVersion} ${app} -i dummy --docker ${dockerTag}:${mType}${dockerNewVersion} --dump cwl --metadata version=${dockerNewVersion} --scatter input_reference > app-${app}${appType}${dockerNewVersion}.cwl"

                    sh "cat app-${app}${appType}${dockerNewVersion}.cwl"

                  
                    withAWS(endpointUrl: 'https://s3.fr-par.scw.cloud', credentials:'scaleway-s3') {
                        def identity=awsIdentity();
                        // Upload files from working directory to project workspace
                        s3Upload(file: 'app-${app}${appType}${dockerNewVersion}.cwl', bucket:"app-packages", path: '{app}');
                    }

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