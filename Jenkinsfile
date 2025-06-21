pipeline {
  agent any

  environment {
    IMAGE_NAME = "shashikanth044/react-app"
    TAG = "latest"
    DOCKER_CREDENTIALS_ID = "docket-test-id"     // Create this in Jenkins Credentials
    KUBECONFIG_CREDENTIALS_ID = 'kubeconfig-creds'
  }

  stages {
    stage('Checkout Code') {
      steps {
        checkout scm
      }
    }

    stage('Install Dependencies') {
      steps {
        bat 'npm install'
      }
    }

    stage('Build React App') {
      steps {
        bat 'npm run build'
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          bat "docker build -t ${IMAGE_NAME}:${TAG} ."
        }
      }
    }

    stage('Push Docker Image to Docker Hub') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: 'docket-test-id',
          usernameVariable: 'DOCKER_USER',
          passwordVariable: 'DOCKER_PASS'
        )]) {
          bat '''
            echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin
            docker push %DOCKER_USER%/react-app:latest
          '''
        }
      }
    }


   stage('Deploy to Kubernetes') {
  steps {
    withCredentials([file(credentialsId: "${KUBECONFIG_CREDENTIALS_ID}", variable: 'KUBECONFIG_FILE')]) {
      bat '''
        set KUBECONFIG=%KUBECONFIG_FILE%
        kubectl apply -f k8s\\deployment.yaml
        kubectl apply -f k8s\\service.yaml
      '''
    }
  }
}

  }

  post {
    failure {
      echo 'Pipeline failed! Check logs.'
    }
    success {
      echo 'Deployment complete! React app is live on Kubernetes.'
    }
  }
}
