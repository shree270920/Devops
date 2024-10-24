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

        stage('Docker Login') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'DivyaShreeDocker', usernameVariable: 'divyashree27', passwordVariable: 'Ndshree27@')]) {
                        sh 'docker login -u $DOCKERHUB_USERNAME -p $DOCKERHUB_PASSWORD'
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dir("${WORKSPACE}") {
                        sh 'docker build -t $DOCKERHUB_DEV_REPO:latest .'
                    }
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    sh 'docker push $DOCKERHUB_DEV_REPO:latest'
                    if (env.BRANCH_NAME == 'main') {
                        sh 'docker tag $DOCKERHUB_DEV_REPO:latest $DOCKERHUB_PROD_REPO:latest'
                        sh 'docker push $DOCKERHUB_PROD_REPO:latest'
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
