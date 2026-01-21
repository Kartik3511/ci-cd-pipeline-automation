#!/bin/bash

IMAGE_NAME=$1

echo "Pulling latest image..."
docker pull $IMAGE_NAME

echo "Stopping old container..."
docker stop ci-cd-app || true
docker rm ci-cd-app || true

echo "Starting new container..."
docker run -d -p 8080:8080 --name ci-cd-app $IMAGE_NAME
