#!/bin/bash

# Deployment script for MEAN stack application
# This script should be run on the Ubuntu VM

set -e

echo "🚀 Starting deployment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Docker is not installed. Please install Docker first.${NC}"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}Docker Compose is not installed. Please install Docker Compose first.${NC}"
    exit 1
fi

# Navigate to project directory
PROJECT_DIR="${HOME}/mean-app"
if [ ! -d "$PROJECT_DIR" ]; then
    echo -e "${YELLOW}Project directory not found. Creating...${NC}"
    mkdir -p "$PROJECT_DIR"
fi

cd "$PROJECT_DIR"

# Pull latest code if git repository exists
if [ -d ".git" ]; then
    echo -e "${GREEN}Pulling latest code...${NC}"
    git pull origin main || git pull origin master
else
    echo -e "${YELLOW}Not a git repository. Skipping git pull.${NC}"
fi

# Login to Docker Hub if credentials are provided
if [ ! -z "$DOCKER_HUB_USERNAME" ] && [ ! -z "$DOCKER_HUB_TOKEN" ]; then
    echo -e "${GREEN}Logging in to Docker Hub...${NC}"
    echo "$DOCKER_HUB_TOKEN" | docker login -u "$DOCKER_HUB_USERNAME" --password-stdin
fi

# Pull latest images
echo -e "${GREEN}Pulling latest Docker images...${NC}"
docker-compose pull || echo -e "${YELLOW}Warning: Could not pull images. Building locally...${NC}"

# Stop existing containers
echo -e "${GREEN}Stopping existing containers...${NC}"
docker-compose down

# Build images if needed
if [ "$1" == "--build" ]; then
    echo -e "${GREEN}Building Docker images...${NC}"
    docker-compose build
fi

# Start containers
echo -e "${GREEN}Starting containers...${NC}"
docker-compose up -d

# Wait for services to be ready
echo -e "${GREEN}Waiting for services to start...${NC}"
sleep 10

# Check container status
echo -e "${GREEN}Container status:${NC}"
docker-compose ps

# Clean up old images
echo -e "${GREEN}Cleaning up old images...${NC}"
docker image prune -f

echo -e "${GREEN}✅ Deployment completed successfully!${NC}"
echo -e "${GREEN}Application should be available at: http://$(hostname -I | awk '{print $1}')${NC}"

# Show logs
echo -e "${YELLOW}Showing recent logs (Ctrl+C to exit):${NC}"
docker-compose logs --tail=50 -f
