#!/usr/bin/env groovy

@Library('jenkins-shared-library') _

pipeline {
    agent any
    tools {
        maven 'Maven'
    }
    environment {
        IMAGE_NAME = 'hammedbabatunde/demo-app:java-maven-1.0'
    }
    stages {  
        // stage('increment version') {
        //     steps {
        //         script {
        //             echo 'incrementing app version...'
        //             sh 'mvn build-helper:parse-version versions:set \
        //                 -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} \
        //                 versions:commit'
        //             def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
        //             def version = matcher[0][1]
        //             env.IMAGE_NAME = "$version-$BUILD_NUMBER"
        //         }
        //     }
        // }
    
        stage('build app') {
            steps {
                script {
                    echo "building the application jar..."
                    buildJar()
                }
            }
        }
        stage('build image') {
            steps {
                script {
                    echo "building the docker image..."
                    buildImage(env.IMAGE_NAME)
                    dockerLogin()
                    dockerPush(env.IMAGE_NAME)
                }
            }
        }
        stage('deploy') {
            steps {
                script {
                    def dockerComposeCmd = "docker-compose -f docker-compose.yml up --detach"
                    sshagent(['ec2-server-key']) {
                        sh "scp docker-compose.yaml babatunde@20.231.202.175:/home/babatunde"
                        sh "ssh -o StrictHostKeyChecking=no babatunde@20.231.202.175 ${dockerComposeCmd}"
                    }
                }
            }
        }
        // stage ('commit version update') {
        //     steps {
        //         script {
        //             withCredentials([usernamePassword(credentialsId: 'git-credentials', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
        //                 sh 'git config --global user.email "jenkins@example.com"'
        //                 sh 'git config --global user.name "HammedBabatunde"'

        //                 sh 'git status'
        //                 sh 'git branch'
        //                 sh 'git config --list'

        //                 sh 'git add .'
        //                 sh 'git commit -m "ci: version bump"'
        //                 sh 'git push origin HEAD:jenkins-jobs'
        //             }
        //         }
        //     }
        // }
    }
}
