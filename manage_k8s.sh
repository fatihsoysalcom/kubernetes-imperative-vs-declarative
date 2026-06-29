#!/bin/bash

# This script demonstrates imperative vs. declarative Kubernetes management.
# It's a simplified simulation and requires kubectl configured to a cluster.

# --- Imperative Management Example ---
# "Do this!" approach. Each command is an explicit instruction.

echo "--- Starting Imperative Management ---"

# 1. Create a Deployment
echo "Creating Deployment imperatively..."
kubectl create deployment nginx-imperative --image=nginx:latest --replicas=1
# Wait for deployment to be ready (optional but good practice)
sleep 5

# 2. Expose the Deployment with a Service
echo "Creating Service imperatively..."
kubectl expose deployment nginx-imperative --port=80 --target-port=80 --type=ClusterIP --name=nginx-imperative-svc
sleep 5

# 3. Scale the Deployment
echo "Scaling Deployment imperatively..."
kubectl scale deployment nginx-imperative --replicas=2
sleep 5

# 4. View current state
echo "Current state after imperative commands:"
kubectl get deployments,services

# --- Cleanup Imperative Resources ---
echo "Cleaning up imperative resources..."
kubectl delete service nginx-imperative-svc
kubectl delete deployment nginx-imperative
sleep 5

# --- Declarative Management Example ---
# "Here's what I want!" approach. Define the desired state in a YAML file.

echo "\n--- Starting Declarative Management ---"

# Define desired state in YAML files
cat <<EOF > deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-declarative
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-declarative
  template:
    metadata:
      labels:
        app: nginx-declarative
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
EOF

cat <<EOF > service.yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-declarative-svc
spec:
  selector:
    app: nginx-declarative
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: ClusterIP
EOF

# 1. Apply the Deployment definition
echo "Applying Deployment declaratively..."
kubectl apply -f deployment.yaml
sleep 5

# 2. Apply the Service definition
echo "Applying Service declaratively..."
kubectl apply -f service.yaml
sleep 5

# 3. Scale the Deployment by updating the YAML and reapplying
echo "Updating Deployment to 2 replicas declaratively..."
sed -i 's/replicas: 1/replicas: 2/' deployment.yaml
kubectl apply -f deployment.yaml
sleep 5

# 4. View current state
echo "Current state after declarative commands:"
kubectl get deployments,services

# --- Cleanup Declarative Resources ---
echo "Cleaning up declarative resources..."
kubectl delete -f deployment.yaml
kubectl delete -f service.yaml
rm deployment.yaml service.yaml

echo "\n--- Demonstration Complete ---"
