#!/bin/bash

set -e

echo "Creating Kind cluster..."
kind create cluster --config ./kind-config.yaml --name muchtodo-cluster

echo "Creating namespace..."
kubectl apply -f kubernetes/namespace.yaml

echo "Deploying MongoDB..."
kubectl apply -f kubernetes/mongodb

echo "Waiting for MongoDB to be ready..."
kubectl wait --namespace=muchtodo --for=condition=ready pod -l app=mongodb --timeout=300s

echo "Creating local registry..."
sudo docker run -d --restart=always -p "5001:5000" --name "kind-registry" registry:2

echo "Connecting registry to Kind network..."
sudo docker network connect kind kind-registry

echo "Building and pushing application image..."
./scripts/docker-build.sh

echo "Deploying backend application..."
kubectl apply -f kubernetes/backend

echo "Deploying ingress..."
kubectl apply -f kubernetes/ingress.yaml

echo "Waiting for backend to be ready..."
kubectl wait --namespace=muchtodo --for=condition=ready pod -l app=backend --timeout=120s

echo "Deployment completed!"
echo "Access the application at: http://localhost"
