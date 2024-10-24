pipeline {
    agent any

    environment {
        DOCKERHUB_USERNAME = 'divyashree27'
        DOCKERHUB_PASSWORD = credentials('DivyaShreeDocker')
        DOCKERHUB_DEV_REPO = "divyashree27/dev"
        DOCKERHUB_PROD_REPO = "divyashree27/prod"
    }

    triggers {
        githubPush()
    }

    stages {
        stage('Setup Docker Config') {
            steps {
                sh 'mkdir -p ~/.docker'
                sh 'echo \'{ "auths": { "https://index.docker.io/v1/": { "auth": "${DOCKERHUB_USERNAME}:${DOCKERHUB_PASSWORD}" } } }\' > ~/.docker/config.json'
            }
        }

        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout Code') {
            steps {
                checkout scm
                sh 'ls -la'
            }
        }

        stage('Manual Docker Login') {
            steps {
                script {
                    sh 'echo ${DOCKERHUB_PASSWORD} | docker login -u ${DOCKERHUB_USERNAME} --password-stdin'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dir("${WORKSPACE}") {
                        docker.build("${DOCKERHUB_DEV_REPO}:latest", '.')
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
