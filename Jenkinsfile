#!/usr/bin/env groovy
// @Library('jenkins-shared-libary')

libary identifier: 'jenkins-shared-libary@master', retriver: modernSCM(
    [$class: 'GitSCMSource',
    remote:'https://github.com/HammedBabatunde/jenkins-shared-libary.git',
    credentialsId:'git-credentials'
    ]
)


def gv

pipeline {
    agent any
    tools {
        maven 'Maven'
    }
    stages {
        stage("init") {
            steps {
                script {
                    gv = load "script.groovy"
                }
            }
        }
        stage("build jar") {
            steps {
                script {
                    buildJar()
                }
            }
        }
        stage("build and push image") {
            steps {
                script {
                    buildImage 'hammedbabatunde/my-repo:jma-3.0'
                    dockerLogin()
                    dockerPush 'hammedbabatunde/my-repo:jma-3.0'
                }
            }
        }
        stage("deploy") {
            steps {
                script {
                    gv.deployApp()
                }
            }
        }
    }
}
