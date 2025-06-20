pipeline {
    agent any

    tools {
        nodejs 'Node24' // Match the name configured in Jenkins > Global Tools
    }

    environment {
        CI = 'true'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Debug List Files') {
            steps {
                bat 'dir /s'
            }
        }
        stage('Clean Install') {
            steps {
                bat 'rmdir /s /q node_modules'
                bat 'npm install'
            }
        }
        stage('Test') {
            steps {
                bat 'npm test'
            }
        }
        stage('Deliver') {
            steps {
                bat './jenkins/scripts/deliver.bat'
                input message: 'Finished using the web site? (Click "Proceed" to continue)'
                bat './jenkins/scripts/kill.bat'
            }
        }
    }
}
