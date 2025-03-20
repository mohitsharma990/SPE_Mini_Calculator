pipeline {
    agent any

    environment {
        PATH = "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
        DOCKER_IMAGE_NAME = 'spe_mini_calc'
        GITHUB_REPO_URL = 'https://github.com/mohitsharma990/SPE_Mini_Calculator.git'
        ANSIBLE_PATH = "/opt/homebrew/bin/ansible-playbook"
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

        stage('Testing') {
            steps {
                script {
                    // Run JUnit tests using Maven Surefire plugin
                    sh 'mvn clean test'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(
                        credentialsId: 'DockerHubCred',   // Use Docker Hub PAT
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )]) {
                        sh '''
                        echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
                        docker tag spe_mini_calc iitgmohitsharma/spe_mini_calc:latest
                        docker push iitgmohitsharma/spe_mini_calc:latest
                        '''
                    }
                }
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                script {
                    withEnv(["ANSIBLE_HOST_KEY_CHECKING=False"]) {
                        // Use full path to Ansible playbook
                        sh "/opt/homebrew/bin/ansible-playbook -i inventory deploy.yml"
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