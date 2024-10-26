pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'development', url: 'https://github.com/shree270920/Devops'
            }
        }
        // stage('Build') {
        //     steps {
        //         sh 'npm install'
        //         sh 'npm run build'
        //     }
        // }
        // stage('Test') {
        //     steps {
        //         sh 'npm test'
        //     }
        // }
        stage('Docker Build') {
    steps {
        sh 'DOCKER_BUILDKIT=1 docker build -t shree2000/your-image-name:latest .'
    }
}

        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'Docker-Password', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                    sh 'docker push shree2000/your-image-name:latest'
                }
            }
        }
        stage('Deploy to Staging') {
            steps {
                sh 'ssh -i /home/divya/guvi.pem ubuntu@ec2-3-93-210-82.compute-1.amazonaws.com "docker pull shree2000/your-image-name:latest && docker run -d -p 80:80 shree2000/your-image-name:latest"'
            }
        }
    }

    post {
        always {
            mail to: 'shree27092000@gmail.com',
                 subject: "Pipeline ${currentBuild.fullDisplayName}",
                 body: "Pipeline ${currentBuild.fullDisplayName} finished with status ${currentBuild.result}"
        }
    }
}
