pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = 'localhost:5000'
        IMAGE_NAME_BACKEND = 'todo-backend'
        IMAGE_NAME_FRONTEND = 'todo-frontend'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', 
                    url: 'https://github.com/Idriss-rayan/todoTask.git'
                // Pour l'instant, on utilise le dépôt local
                // checkout scm
            }
        }

        stage('Build Backend Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME_BACKEND}:latest", "./backend")
                }
            }
        }

        stage('Build Frontend Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME_FRONTEND}:latest", "./frontend/")
                }
            }
        }

        stage('Test Backend') {
            steps {
                sh '''
                    docker run --rm ${IMAGE_NAME_BACKEND}:latest python -c "import fastapi; print('FastAPI OK')"
                '''
            }
        }

        stage('Deploy with Docker Compose') {
            steps {
                sh '''
                    docker compose down
                    docker compose up -d --build
                '''
            }
        }

        stage('Health Check') {
            steps {
                sh '''
                    sleep 10
                    curl -f http://localhost:8000/todos/ || exit 1
                    curl -f http://localhost:8080 || exit 1
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Déploiement réussi !'
        }
        failure {
            echo '❌ Échec du pipeline'
        }
    }
}