pipeline {
    environment {
        dockerhubRegitry = "dariazhdanovadev/cicd-exam-images"
        dockerhubCreds = 'dockerhub'
    }
    agent { label 'alpine'}
    options {
        timestamps()
    }
    
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
                    coverage xml
                '''
            }
        }

        stage('Publish reports') {
            steps{
        cobertura(
            onlyStable: false,
            enableNewApi: true,
            failUnhealthy: false,
            failUnstable: false,
            autoUpdateHealth: false,
            autoUpdateStability: false,
            zoomCoverageChart: false,
            maxNumberOfBuilds: 0,
            sourceEncoding: 'ASCII',
            coberturaReportFile: 'coverage.xml',
            lineCoverageTargets: '80, 0, 0',
            methodCoverageTargets: '80, 0, 0',
            conditionalCoverageTargets: '70, 0, 0'
        )
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
                    docker.withRegistry( '', dockerhubCreds ) {
                        dockerImage.push("$BUILD_NUMBER")}
                }
            }
            post {
            always{
                    echo "-------------------CLEANING UP-------------------"
                    sh "docker rmi $dockerhubRegitry:$BUILD_NUMBER"
            }
        }
    }
}
}