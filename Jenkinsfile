pipeline {
    agent any

    environment {
        DOCKER_CONFIG = "$WORKSPACE/.docker"
        DOCKERHUB_DEV_REPO = "shree2000/dev"
        DOCKERHUB_PROD_REPO = "shree2000/prod"
    }

    stages {
        stage('Setup Docker Config') {
            steps {
                sh 'mkdir -p $DOCKER_CONFIG'
                sh 'echo \'{ "auths": { "https://index.docker.io/v1/": { "auth": "c2hyZWUyMDAwOk5kc2hyZWUyNw==" } } }\' > $DOCKER_CONFIG/config.json'
            }
        }

        stage('Clean Workspace') {
            steps {
                cleanWs()
                sh 'rm -rf * .git'
            }
        }

        stage('Checkout Code') {
            steps {
                checkout scm
                sh 'ls -la'
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
