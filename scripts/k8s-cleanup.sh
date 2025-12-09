#!/bin/bash

set -e

echo "Deleting Kubernetes resources..."
kubectl delete -f kubernetes/ingress.yaml
kubectl delete -f kubernetes/backend/
kubectl delete -f kubernetes/mongodb/
kubectl delete -f kubernetes/namespace.yaml

echo "Deleting Kind cluster..."
kind delete cluster --name muchtodo-cluster

echo "Stopping local registry..."
sudo docker stop kind-registry
sudo docker rm kind-registry

echo "Cleanup completed!"
