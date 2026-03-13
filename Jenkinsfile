pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = "apawat01"
        IMAGE_NAME = "finead-todo-app"
        DOCKER_HUB_CREDS = 'jenkins-credentials' 
    }

    stages {
        stage('Clone') {
            steps {
                echo 'Cloning repository...'
                checkout scm
            }
        }

        stage('Install') {
            steps {
                dir('TODO/todo_backend') {
                    echo 'Installing backend dependencies...'
                    sh 'npm ci'
                }

                dir ("TODO/todo_frontend") {
                    echo "Installing frontend dependencies..."
                    sh "npm ci"

                }
            }
        }

        stage("Build"){
            steps {
                dir("TODO/todo_frontend"){
                    echo "Building React Frontend...."
                    sh "npm run build"
                }

                dir("TODO/todo_frontend"){
                    echo "Moving frontend build artifact to backend static folder..."
                    sh "mv build ../todo_backend/static"
                }
            }
        }

        stage('Login') { 
            steps { 
                echo 'Logging into Docker Hub...'
                withCredentials([usernamePassword(
                    credentialsId: "${DOCKER_HUB_CREDS}", 
                    passwordVariable: 'DOCKER_PASS', 
                    usernameVariable: 'DOCKER_USER'
                )]) { 
                    sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin" 
                } 
            } 
        }

        stage('Deploy') { 
            steps { 
                echo 'Build and Push image to Docker Hub...'
                sh "docker build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:1.0 ."
                sh "docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:1.0" 
            } 
        } 
    }

    post {
        success {
            echo "Succeed"
        }
        failure {
            echo "Pipeline failed. Check the logs above for details."
        }
        always {
            // Clean up the workspace after each run to save disk space
            cleanWs()
        }
    }
}
