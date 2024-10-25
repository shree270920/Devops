pipeline {
    agent any

    environment {
        DOCKERHUB_USERNAME = 'shree2000'
        DOCKERHUB_PASSWORD = credentials('Docker_Password')
        DOCKERHUB_DEV_REPO = "shree2000/dev"
        DOCKERHUB_PROD_REPO = "shree2000/prod"
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
                    withCredentials([usernamePassword(credentialsId: 'Docker_Password', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh 'echo $PASSWORD | docker login -u $USERNAME --password-stdin'
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
                        withCredentials([usernamePassword(credentialsId: 'Docker_Password', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                            sh 'echo $PASSWORD | docker login -u $USERNAME --password-stdin'
                            sh 'docker push $DOCKERHUB_PROD_REPO:latest'
                        }
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
