# GitHub Actions CI/CD Pipeline

This directory contains the CI/CD workflow configuration.

## Workflow File

- `ci-cd.yml`: Main CI/CD pipeline that builds, pushes, and deploys the application

## How It Works

1. **Trigger**: On push to main/master branch
2. **Build**: Creates Docker images for backend and frontend
3. **Push**: Uploads images to Docker Hub
4. **Deploy**: SSH into VM and updates running containers

## Required Secrets

Configure these in GitHub repository settings:

- `DOCKER_HUB_USERNAME`: Your Docker Hub username
- `DOCKER_HUB_TOKEN`: Docker Hub access token
- `VM_HOST`: VM IP address or domain
- `VM_USER`: SSH username (usually `ubuntu`)
- `VM_SSH_KEY`: Private SSH key for VM access

## Testing the Pipeline

1. Make a small change to any file
2. Commit and push:
   ```bash
   git add .
   git commit -m "Test CI/CD"
   git push origin main
   ```
3. Check Actions tab in GitHub
4. Monitor the workflow execution
