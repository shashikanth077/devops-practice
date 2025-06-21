//Jenkins
Clone the repo
Install jenkins
Configure using jenkins scm
then build in jenkins

//Docker image create and create container steps
docker build -t shashikanth044/react-app:latest .
docker run -d -p 3000:80 shashikanth044/react-app:latest

//push the image to docker hub
docker login
docker tag IMAGE_ID your-dockerhub-username/image-name:tag //format to tag image
docker tag bf643accad13 shashikanth044/react-app:latest
docker push shashikanth044/react-app:latest

//pull and run the same image
docker pull shashikanth044/react-app:latest
docker run -d -p 3000:80 shashikanth044/react-app:latest

// deploying using kuberenetes
Step-by-Step Kubernetes Commands for React App Deployment
🔰 Step 1: Start Minikube
minikube start

🔍 Step 2: Check Minikube Status (Optional)
minikube status

⚙️ Step 3: Switch Context to Minikube (Optional but safe)
kubectl config use-context minikube

📁 Step 4: Create Kubernetes Deployment YAML
Create a file named deployment.yaml with your React app deployment spec.
kubectl apply -f deployment.yaml


🔁 Step 5: Create Kubernetes Service YAML
Create a file named service.yaml to expose your deployment.
Then apply it:
kubectl apply -f service.yaml


📋 Step 6: Check Kubernetes Resources
kubectl get deployments
kubectl get pods
kubectl get services

You should see your React app pod and a service like react-kube-service.

🌐 Step 7: Access the App via NodePort
Check the service with Minikube:

minikube service react-kube-service

🔚 Step 8: Delete Resources (Optional Cleanup)
kubectl delete -f deployment.yaml
kubectl delete -f service.yaml


✅ Bonus Commands
Inspect logs (for a specific pod):
kubectl get pods
kubectl logs <pod-name>

Shell into the pod (if needed):
kubectl exec -it <pod-name> -- /bin/sh

/Overall flow for different env
Build → Test → Deploy to Dev → Verify → Deploy to Staging → Verify → Deploy to Prod → Monitor & Maintain
