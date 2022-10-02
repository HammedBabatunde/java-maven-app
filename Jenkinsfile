#!/usr/bin/env groovy

pipeline {
    agent any
    tools {
        maven 'Maven'
    }
    environment {
        DOCKER_REPO_SERVER = '030823258207.dkr.ecr.us-east-1.amazonaws.com'
        DOCKER_REPO = "${DOCKER_REPO_SERVER}/java-maven-app"
    }
    stages {  
        stage('increment version') {
            steps {
                script {
                    echo 'incrementing app version...'
                    sh 'mvn build-helper:parse-version versions:set \
                        -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} \
                        versions:commit'
                    def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
                    def version = matcher[0][1]
                    env.IMAGE_NAME = "$version-$BUILD_NUMBER"
                }
            }
        }
    
        stage('build app') {
            steps {
                script {
                    echo "building the application jar..."
                    sh 'mvn clean package'
                }
            }
        }
        stage('build image') {
            steps {
                script {
                    echo "building the docker image..."
                    withCredentials([usernamePassword(credentialsId: 'ecr-credentials', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        sh "docker build -t ${DOCKER_REPO}:${IMAGE_NAME} ."
                        sh "echo $PASS | docker login -u $USER --password-stdin ${DOCKER_REPO_SERVER}"
                        sh "docker push ${DOCKER_REPO}:${IMAGE_NAME}"
                    }
 
                }
            }
        }
        stage('deploy') {
            environment {
                APP_NAME = 'java-maven-app'
            }
            steps {
                script {

                    // Deploy to EC2 instance
                    // def dockerComposeCmd = "sudo docker-compose -f docker-compose.yaml up -d"

                    // def shellCmd = "bash ./server-cmds.sh ${IMAGE_NAME}"
                    // sshagent(['ec2-server-key']) {
                    //     sh "scp server-cmds.sh babatunde@20.231.202.175:/home/babatunde"
                    //     sh "scp docker-compose.yaml babatunde@20.231.202.175:/home/babatunde"
                    //     sh "ssh -o StrictHostKeyChecking=no babatunde@20.231.202.175 ${shellCmd}"
                    // }

                    // Deploy to Kubernetes
                    echo "deploying the application to kubernetes..."
                    sh 'envsubst < kubernetes/deployment.yaml | kubectl apply -f -'
                    sh 'envsubst < kubernetes/service.yaml | kubectl apply -f -'
                }
            }
        }
        stage ('commit version update') {
            steps { 
                script {
                    withCredentials([usernamePassword(credentialsId: 'git-credentials', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        sh 'git config --global user.email "jenkins@example.com"'
                        sh 'git config --global user.name "HammedBabatunde"'

                        sh 'git status'
                        sh 'git branch'
                        sh 'git config --list'

                        sh 'git add .'
                        sh 'git commit -m "ci: version bump"'
                        sh 'git push origin HEAD:deploy-on-k8'
                    }
                }
            }
        }
    }
}
