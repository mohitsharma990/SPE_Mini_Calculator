pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = 'spe_mini_calc'
        GITHUB_REPO_URL = 'https://github.com/mohitsharma990/SPE_Mini_Calculator.git'
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
                    // Build Docker image
                    docker.build("${DOCKER_IMAGE_NAME}", '.')
                }
            }
        }

        stage('Push Docker Images') {
                    steps {
                        script{
                            docker.withRegistry('', 'DockerHubCred') {
                            sh 'docker tag spe_mini_calc iitgmohitsharma/spe_mini_calc:latest'
                            sh 'docker push iitgmohitsharma/spe_mini_calc:latest'
                            }
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
}