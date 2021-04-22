def dockerRegistry = 'docker.terradue.com'

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
  
                    docker.withRegistry("https://${dockerRegistry}", 'docker-terradue') {
                     app.push("${mType}${dockerNewVersion}")
                      app.push("${mType}latest")
                    }
                }
            }
        }

        stage('Publish Artifact') {
            agent { node { label 'artifactory' } }
            steps {
                script {
                    echo 'Deploying application package artifacts'

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