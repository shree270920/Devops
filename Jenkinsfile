pipeline {
    agent any

    environment {
        DOCKERHUB_USERNAME = 'shree2000'
        DOCKERHUB_PASSWORD = credentials('Docker_Password')
        DOCKERHUB_DEV_REPO = "shree2000/dev"
        DOCKERHUB_PROD_REPO = "shree2000/prod"
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
                sh 'ls -la'
            }
        }

        stage('Docker Login') {
            steps {
                script {
                    sh 'docker login -u ${DOCKERHUB_USERNAME} --password-stdin'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dir("${WORKSPACE}") {
                        sh 'docker build -t ${DOCKERHUB_DEV_REPO}:latest .'
                    }
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    sh 'docker push ${DOCKERHUB_DEV_REPO}:latest'
                    if (env.BRANCH_NAME == 'main') {
                        sh 'docker tag ${DOCKERHUB_DEV_REPO}:latest ${DOCKERHUB_PROD_REPO}:latest'
                        sh 'echo ${DOCKERHUB_PASSWORD} | docker login -u ${DOCKERHUB_USERNAME} --password-stdin'
                        sh 'docker push ${DOCKERHUB_PROD_REPO}:latest'
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
