#!/bin/bash

# Function to check if a command exists
function check_dependency {
  if ! command -v $1 &> /dev/null; then
    echo "$1 could not be found. Installing..."
    if [[ "$1" == "minikube" ]]; then
      curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
      chmod +x minikube && sudo mv minikube /usr/local/bin/
    elif [[ "$1" == "kubectl" ]]; then
      curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
      chmod +x kubectl && sudo mv kubectl /usr/local/bin/
    elif [[ "$1" == "docker" ]]; then
      sudo apt-get update && sudo apt-get install docker-ce docker-ce-cli containerd.io
    fi
  else
    echo "$1 is already installed."
  fi
}

# Check for dependencies: Minikube, kubectl, docker
check_dependency "minikube"
check_dependency "kubectl"
check_dependency "docker"

# Start Minikube if it's not running
if ! minikube status &> /dev/null; then
  echo "Starting Minikube..."
  minikube start
else
  echo "Minikube is already running."
fi

# Configure Docker to use Minikube's Docker daemon
eval $(minikube docker-env)

# Build the Docker image
echo "Building Docker image for Spark job..."
docker build -t spark-minikube .

# Apply the Spark job YAML to Kubernetes
echo "Deploying Spark job to Minikube..."
kubectl apply -f kubernetes/spark-job.yaml

# Monitor the status of the Spark job
echo "Monitoring Spark job..."
kubectl get pods

# Optionally open the Kubernetes dashboard
echo "Launching Kubernetes Dashboard..."
minikube dashboard
