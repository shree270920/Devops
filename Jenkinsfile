pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
                sh 'ls -la'
            }
        }

        stage('Build') {
            steps {
                script {
                    echo 'Building...'
                    sh 'echo Hello, Jenkins!'
                }
            }
        }
    }

    post {
        success {
            echo 'Build was successful!'
        }
        failure {
            echo 'Build failed.'
        }
    }
}
