#!/usr/bin/env groovy

pipeline {
    agent any
    stages {
        stage('test') {
            steps {
                script {
                    echo "Testing the application"
                }
            }
        }

        stage('build') {
            steps {
                script {
                    echo "Testing the application..."
                }
            }
        }

        stage('deploy') {
            steps {
                script {
                    def dockerCmd = 'docker run -p 3080:3080 -d hammedbabatunde/demo-app:1.0'
                    sshagent(['ec2-server-key']) {
                        sh "ssh -o StrictHostKeyChecking=no babatunde@20.231.202.175 ${dockerCmd}"
                    }
                }
            }
        }
    }
}
