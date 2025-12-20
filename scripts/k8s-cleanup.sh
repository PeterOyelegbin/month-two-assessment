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
docker stop kind-registry
docker rm kind-registry

echo "Removing orphan containers and unused volumes"
docker system prune -a
docker system prune --volumes

echo "Cleanup completed!"
