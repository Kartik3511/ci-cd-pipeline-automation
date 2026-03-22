#!/bin/bash

# FoodGlance Deployment Script
# Usage: ./deploy.sh <docker-image-name>

set -e  # Exit on error

IMAGE_NAME=$1

if [ -z "$IMAGE_NAME" ]; then
    echo "❌ Error: Docker image name not provided"
    echo "Usage: ./deploy.sh <docker-image-name>"
    exit 1
fi

CONTAINER_NAME="ci-cd-app"
PORT=8080

echo "========================================="
echo "FoodGlance Deployment"
echo "========================================="
echo "Image: $IMAGE_NAME"
echo "Container: $CONTAINER_NAME"
echo "Port: $PORT"
echo ""

# Pull latest image
echo "📥 Pulling latest Docker image..."
docker pull $IMAGE_NAME

# Stop and remove old container (if exists)
echo "🛑 Stopping old container..."
docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm $CONTAINER_NAME 2>/dev/null || true

# Start new container with environment variables
echo "🚀 Starting new container..."
docker run -d \
    -p $PORT:8080 \
    --name $CONTAINER_NAME \
    --restart unless-stopped \
    -e GOOGLE_VISION_API_KEY="${GOOGLE_VISION_API_KEY}" \
    -e USDA_API_KEY="${USDA_API_KEY}" \
    -e PORT=8080 \
    --health-cmd="curl -f http://localhost:8080/health || exit 1" \
    --health-interval=30s \
    --health-timeout=3s \
    --health-retries=3 \
    $IMAGE_NAME

echo ""
echo "⏳ Waiting for container to be healthy..."
sleep 5

# Check if container is running
if docker ps | grep -q $CONTAINER_NAME; then
    echo "✅ Container is running!"
    
    # Show container details
    echo ""
    echo "📊 Container Status:"
    docker ps --filter name=$CONTAINER_NAME --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    
    echo ""
    echo "========================================="
    echo "✅ Deployment completed successfully!"
    echo "========================================="
    echo "Application is available at: http://localhost:$PORT"
    echo "Health check: http://localhost:$PORT/health"
    echo "Version: http://localhost:$PORT/version"
    echo ""
    echo "To view logs: docker logs -f $CONTAINER_NAME"
    echo "To stop: docker stop $CONTAINER_NAME"
    echo "========================================="
else
    echo "❌ Container failed to start!"
    echo ""
    echo "Container logs:"
    docker logs $CONTAINER_NAME 2>&1 || true
    exit 1
fi
