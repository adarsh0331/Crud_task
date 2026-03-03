# Deployment Guide

This guide provides step-by-step instructions for deploying the MEAN stack application.

## Prerequisites

- Docker and Docker Compose installed
- GitHub account
- Docker Hub account
- Ubuntu VM on cloud platform (AWS, Azure, GCP, etc.)
- SSH access to the VM

## Step 1: Repository Setup

1. Create a new GitHub repository
2. Push the code to the repository:
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin <your-github-repo-url>
   git push -u origin main
   ```

## Step 2: Docker Hub Setup

1. Create a Docker Hub account at https://hub.docker.com
2. Note your Docker Hub username

## Step 3: Build and Push Docker Images Locally (Optional)

You can build and push images manually:

```bash
# Build backend image
cd backend
docker build -t <your-dockerhub-username>/mean-backend:latest .
docker push <your-dockerhub-username>/mean-backend:latest

# Build frontend image
cd ../frontend
docker build -t <your-dockerhub-username>/mean-frontend:latest .
docker push <your-dockerhub-username>/mean-frontend:latest
```

## Step 4: Setup Ubuntu VM

### 4.1 Launch Ubuntu VM

- AWS EC2: Launch Ubuntu 22.04 LTS instance
- Azure: Create Ubuntu 22.04 LTS VM
- GCP: Create Ubuntu 22.04 LTS VM instance

### 4.2 Install Docker and Docker Compose

SSH into your VM and run:

```bash
# Update system
sudo apt-get update

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Logout and login again for group changes to take effect
```

### 4.3 Clone Repository

```bash
cd ~
git clone <your-github-repo-url> mean-app
cd mean-app
```

### 4.4 Update Docker Compose (if using custom images)

Edit `docker-compose.yml` and update image names:

```yaml
backend:
  image: <your-dockerhub-username>/mean-backend:latest
  # ... rest of config

frontend:
  image: <your-dockerhub-username>/mean-frontend:latest
  # ... rest of config
```

Or keep using `build` context if building on VM.

## Step 5: Configure GitHub Actions Secrets

1. Go to your GitHub repository
2. Navigate to Settings → Secrets and variables → Actions
3. Add the following secrets:
   - `DOCKER_HUB_USERNAME`: Your Docker Hub username
   - `DOCKER_HUB_TOKEN`: Your Docker Hub access token (create at https://hub.docker.com/settings/security)
   - `VM_HOST`: Your VM's public IP address or domain
   - `VM_USER`: SSH username (usually `ubuntu` or your username)
   - `VM_SSH_KEY`: Your private SSH key content

### Generate SSH Key (if needed)

```bash
ssh-keygen -t rsa -b 4096 -C "github-actions"
# Copy public key to VM
ssh-copy-id <vm-user>@<vm-host>
# Copy private key content to GitHub secret
cat ~/.ssh/id_rsa
```

## Step 6: Deploy Application

### Option A: Manual Deployment

```bash
# On your VM
cd ~/mean-app
docker-compose up -d
```

### Option B: Automated Deployment via CI/CD

1. Push changes to main/master branch
2. GitHub Actions will automatically:
   - Build Docker images
   - Push to Docker Hub
   - Deploy to VM

## Step 7: Verify Deployment

1. Check running containers:
   ```bash
   docker-compose ps
   ```

2. Check logs:
   ```bash
   docker-compose logs -f
   ```

3. Access application:
   - Open browser: `http://<vm-ip-address>`
   - The application should be accessible on port 80

## Step 8: Firewall Configuration

Ensure your VM's security group/firewall allows:
- Port 80 (HTTP) - Inbound
- Port 22 (SSH) - Inbound
- Port 8080, 8081 (optional, for direct access) - Inbound

### AWS Security Group Example:
- Type: HTTP, Protocol: TCP, Port: 80, Source: 0.0.0.0/0
- Type: SSH, Protocol: TCP, Port: 22, Source: Your IP

## Troubleshooting

### MongoDB Connection Issues
```bash
# Check MongoDB container
docker-compose logs mongodb

# Restart MongoDB
docker-compose restart mongodb
```

### Backend Connection Issues
```bash
# Check backend logs
docker-compose logs backend

# Verify MongoDB is running
docker-compose ps mongodb
```

### Frontend Not Loading
```bash
# Check frontend logs
docker-compose logs frontend

# Check Nginx logs
docker-compose logs nginx
```

### CORS Errors
- Ensure CORS is enabled in `backend/server.js`
- Check Nginx configuration in `nginx/nginx.conf`

### Port Already in Use
```bash
# Stop existing containers
docker-compose down

# Check what's using the port
sudo netstat -tulpn | grep :80
```

## Updating the Application

### Manual Update
```bash
cd ~/mean-app
git pull
docker-compose down
docker-compose build
docker-compose up -d
```

### Automatic Update (via CI/CD)
- Push changes to main/master branch
- CI/CD pipeline will handle the rest

## Monitoring

### View Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f mongodb
docker-compose logs -f nginx
```

### Check Container Status
```bash
docker-compose ps
docker stats
```

## Backup MongoDB

```bash
# Create backup
docker exec mean-mongodb mongodump --out /data/backup

# Restore backup
docker exec mean-mongodb mongorestore /data/backup
```

## Clean Up

```bash
# Stop and remove containers
docker-compose down

# Remove volumes (WARNING: Deletes data)
docker-compose down -v

# Remove images
docker rmi <image-name>
```

## Architecture Overview

```
Internet (Port 80)
    ↓
Nginx (Reverse Proxy)
    ↓
    ├──→ Frontend (Angular) - Port 8081
    └──→ Backend (Express) - Port 8080
            ↓
        MongoDB - Port 27017
```

## Support

For issues or questions, check:
- Application logs: `docker-compose logs`
- GitHub Actions logs: Repository → Actions tab
- Docker Hub: Verify images are pushed correctly
