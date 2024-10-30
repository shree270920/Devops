pipeline {
    agent any
    triggers {
        githubPush()
    }
    environment {
        DOCKER_CREDENTIALS_ID = 'Docker_Password'
        DOCKER_IMAGE_DEV = 'shree2000/dev:latest'
        DOCKER_IMAGE_PROD = 'shree2000/prod:latest'
    }
    stages {
        stage('Checkout') {
            steps {
                script {
                    def branches = ['development', 'main']
                    if (branches.contains(env.BRANCH_NAME)) {
                        checkout scm
                    }
                }
            }
        }
        stage('Docker Build') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'development') {
                        sh 'docker build -t ${DOCKER_IMAGE_DEV} .'
                    } else if (env.BRANCH_NAME == 'main') {
                        sh 'docker build -t ${DOCKER_IMAGE_PROD} .'
                    }
                }
            }
        }
        stage('Docker Push') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS_ID}", usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        if (env.BRANCH_NAME == 'development') {
                            sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                            sh 'docker push ${DOCKER_IMAGE_DEV}'
                        } else if (env.BRANCH_NAME == 'main') {
                            sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                            sh 'docker push ${DOCKER_IMAGE_PROD}'
                        }
                    }
                }
            }
        }
        stage('Deploy to Staging') {
            when {
                branch 'development'
            }
            steps {
                sh '''
                    ssh -i /var/lib/jenkins/.ssh/guvi.pem ubuntu@ec2-3-89-54-129.compute-1.amazonaws.com "
                        docker pull ${DOCKER_IMAGE_DEV} &&
                        docker stop $(docker ps -q --filter expose=100) || true &&
                        docker run -d -p 100:80 ${DOCKER_IMAGE_DEV}
                    "
                '''
            }
        }
        stage('Deploy to Production') {
            when {
                branch 'main'
            }
            steps {
                sh '''
                    ssh -i /var/lib/jenkins/.ssh/guvi.pem ubuntu@ec2-3-89-54-129.compute-1.amazonaws.com "
                        docker pull ${DOCKER_IMAGE_PROD} &&
                        docker stop $(docker ps -q --filter expose=100) || true &&
                        docker run -d -p 100:80 ${DOCKER_IMAGE_PROD}
                    "
                '''
            }
        }
    }
}
