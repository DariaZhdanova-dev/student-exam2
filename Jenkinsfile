pipeline {
    environment {
        dockerhubRegitry = "dariazhdanovadev/cicd-exam-images"
        dockerhubCreds = 'dockerhub'
    }
    agent any
    stages {
        stage('Get Code') {
            steps {
                checkout scm
            }
        }
        
        stage('Run Python tests') {
            steps {
                echo '-------------------TEST-------------------'
                sh '''
                    python3 -m venv venv
                    . venv/bin/activate
                    pip install -e '.[test]'
                    coverage run -m pytest
                    coverage report
                '''
            }
        }
        
        stage('Build Docker image') {
            steps {
                script {
                    echo '-------------------BUILD-------------------'
                    dockerImage = docker.build dockerhubRegitry + ":$BUILD_NUMBER"
                }
            }
        }

        stage('Deploy Image') {
            steps {
                script {
                    echo "-------------------DEPLOY-------------------"
                    docker.withRegistry( '', registryCredential ) {
                        dockerImage.push("$BUILD_NUMBER")}
                }
            }
        }
        stage ('Cleaing up'){
            steps{
                    echo "-------------------CLEANING UP-------------------"
                    sh "docker rmi $registry:$BUILD_NUMBER"
            }
        }
    }
}