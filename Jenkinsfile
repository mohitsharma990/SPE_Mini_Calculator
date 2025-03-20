pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = 'spe_mini_calc'
        GITHUB_REPO_URL = 'https://github.com/mohitsharma990/SPE_Mini_Calculator.git'
        PATH+EXTRA = "/opt/homebrew/bin"  // Use PATH+EXTRA to properly extend the PATH
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    // Checkout the code from the GitHub repository
                    git branch: 'main', url: "${GITHUB_REPO_URL}"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Use explicit Docker path to avoid PATH issues
                    sh '/opt/homebrew/bin/docker build -t ${DOCKER_IMAGE_NAME} .'
                }
            }
        }

        stage('Testing') {
            steps {
                script {
                    sh 'mvn clean test'
                }
            }
        }

        stage('Docker Hub Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-hub',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    script {
                        try {
                            sh "/opt/homebrew/bin/docker login -u \"$DOCKER_USER\" -p \"$DOCKER_PASS\""
                        } catch (Exception e) {
                            error "Docker login failed: ${e.getMessage()}"
                        }
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Tag and push Docker image
                    sh '/opt/homebrew/bin/docker tag spe_mini_calc:latest iitgmohitsharma/spe_mini_calc:latest'
                    sh '/opt/homebrew/bin/docker push iitgmohitsharma/spe_mini_calc:latest'
                }
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                script {
                    withEnv(["ANSIBLE_HOST_KEY_CHECKING=False"]) {
                        ansiblePlaybook(
                            playbook: 'deploy.yml',
                            inventory: 'inventory'
                        )
                    }
                }
            }
        }
    }

    post {
        success {
            mail to: 'Mohit.Sharma@iiitb.ac.in',
                 subject: "Application Deployment SUCCESS: Build ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                 body: "The build was successful!"
        }
        failure {
            mail to: 'Mohit.Sharma@iiitb.ac.in',
                 subject: "Application Deployment FAILURE: Build ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                 body: "The build failed."
        }
        always {
            cleanWs()
        }
    }
}