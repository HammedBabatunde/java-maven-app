#!/usr/bin/env groovy

library identifier: 'jenkins-shared-libary@master', retriver: modernSCM{
    [$class: 'GitSCMSource',
      remote: 'https://github.com/HammedBabatunde/jenkins-shared-libary',
      credentialsId: 'git-credentials'
    ]
}

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
                    def dockerCmd = "docker run -p 8080:8080 -d ${IMAGE_NAME}"
                    sshagent(['ec2-server-key']) {
                        sh "ssh -o StrictHostKeyChecking=no babatunde@20.231.202.175 ${dockerCmd}"
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
