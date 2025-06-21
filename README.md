# 🚀 React CI/CD Pipeline with Jenkins, Docker & Kubernetes

This repository demonstrates a full CI/CD pipeline to build, deploy, and manage a React application using:

- Jenkins for automation
- Docker for containerization
- Kubernetes (Minikube) for orchestration
- Docker Hub for image storage

---

## 📦 Tech Stack

- React
- Jenkins
- Docker
- Kubernetes (Minikube)
- Docker Hub

---

## 🧱 Step-by-Step Setup

### ✅ Jenkins Setup

1. **Clone the Repository**
   ```bash
   git clone https://github.com/your-username/react-app.git
   
Install Jenkins

Follow the official guide: Install Jenkins

Configure Jenkins with SCM

Use "Pipeline" project type.

Set the repository URL.

Add your Jenkinsfile.

Run the Jenkins Build

This automates the Docker build, push, and deploy process.

🐳 Docker Workflow
🔨 Build and Run Locally

# Build Docker image
docker build -t docker-user-name/react-app:latest .

# Run container
docker run -d -p 3000:80 docker-user-name/react-app:latest
☁️ Push to Docker Hub

# Login to Docker Hub
docker login

# Tag your image (replace IMAGE_ID with actual one)
docker tag IMAGE_ID docker-user-name/react-app:latest

# Push the image
docker push shashikanth044/react-app:latest
📥 Pull and Run the Image Anywhere
docker pull docker-user-name/react-app:latest
docker run -d -p 3000:80 docker-user-name/react-app:latest

☸️ Kubernetes Deployment (Minikube)
🔰 Step 1: Start Minikube
minikube start

🔍 Step 2: Verify Cluster Status
minikube status

⚙️ Step 3: Use Minikube Context
kubectl config use-context minikube

📁 Step 4: Deploy React App
kubectl apply -f k8s/deployment.yaml

🌐 Step 5: Expose Service
kubectl apply -f k8s/service.yaml

📊 Step 6: Monitor Resources
kubectl get deployments
kubectl get pods
kubectl get services

🔗 Step 7: Access App in Browser
minikube service react-kube-service

🧹 Step 8: Optional Cleanup
kubectl delete -f k8s/deployment.yaml
kubectl delete -f k8s/service.yaml

🧪 Debugging & Monitoring
# View pod logs
kubectl logs <pod-name>

# Open shell inside pod
kubectl exec -it <pod-name> -- /bin/sh
🚦 Environment Promotion Flow
Build → Test → Deploy to Dev → Verify → Deploy to Staging (SVT) → Verify → Deploy to Prod → Monitor & Maintain
Dev: Auto-deployed on each commit

Staging/SVT: Promoted from Dev after approval
Prod: Manually or conditionally promoted after testing

📁 Folder Structure
.
├── Jenkinsfile
├── Dockerfile
├── k8s/
│   ├── deployment.yaml
│   └── service.yaml
├── src/
├── public/
└── ...
