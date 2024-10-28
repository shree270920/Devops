pipeline {
    agent any
    triggers {
        githubPush()
    }
    environment {
        DOCKER_CREDENTIALS_ID = 'Docker_Password'
        DOCKER_IMAGE = 'shree2000/dev:latest'
        GIT_BRANCH = "${env.GIT_BRANCH}"
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
                sh 'docker build -t ${DOCKER_IMAGE} .'
            }
        }
        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKER_CREDENTIALS_ID}", usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                    sh 'docker push ${DOCKER_IMAGE}'
                }
            }
        }
        stage('Deploy to Staging') {
            steps {
                sh '''
                    ssh  -i /var/lib/jenkins/.ssh/guvi.pem ubuntu@ec2-3-89-54-129.compute-1.amazonaws.com "
                        docker pull shree2000/dev:latest &&
                        docker stop \$(docker ps -q --filter expose=100) || true &&
                        docker run -d -p 100:80 shree2000/dev:latest
                    "
                '''
            }
        }
    }
}
