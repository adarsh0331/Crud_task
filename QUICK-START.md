# Quick Start Guide

## 🚀 Fastest Way to Deploy

### Prerequisites Checklist
- [ ] GitHub account
- [ ] Docker Hub account
- [ ] Ubuntu VM (AWS/Azure/GCP)
- [ ] SSH access to VM

### Step 1: Push to GitHub (5 minutes)

```bash
cd crud-dd-task-mean-app
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
git push -u origin main
```

### Step 2: Setup Docker Hub (2 minutes)

1. Create account at https://hub.docker.com
2. Create access token: Account Settings → Security → New Access Token
3. Note your username and token

### Step 3: Setup VM (10 minutes)

```bash
# SSH into VM
ssh ubuntu@your-vm-ip

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Logout and login
exit
ssh ubuntu@your-vm-ip

# Clone repo
cd ~
git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git mean-app
cd mean-app
```

### Step 4: Configure GitHub Secrets (5 minutes)

Go to: GitHub Repo → Settings → Secrets → Actions

Add these secrets:
- `DOCKER_HUB_USERNAME`: your-dockerhub-username
- `DOCKER_HUB_TOKEN`: your-dockerhub-token
- `VM_HOST`: your-vm-ip
- `VM_USER`: ubuntu
- `VM_SSH_KEY`: (see below)

**Get SSH Key:**
```bash
# On your local machine
ssh-keygen -t rsa -b 4096 -f ~/.ssh/github_actions_deploy
ssh-copy-id -i ~/.ssh/github_actions_deploy.pub ubuntu@your-vm-ip
cat ~/.ssh/github_actions_deploy  # Copy this to GitHub secret
```

### Step 5: Deploy (Automatic or Manual)

**Option A: Automatic (Recommended)**
- Push any change to main branch
- GitHub Actions will deploy automatically

**Option B: Manual**
```bash
# On VM
cd ~/mean-app
docker-compose up -d
```

### Step 6: Access Application

Open browser: `http://your-vm-ip`

## ✅ Verify It Works

```bash
# Check containers
docker-compose ps

# Check logs
docker-compose logs -f

# Test API
curl http://your-vm-ip/api/tutorials
```

## 🔧 Common Issues

**Port 80 not accessible?**
- Check VM firewall/security group allows port 80

**Containers not starting?**
```bash
docker-compose logs
docker-compose down
docker-compose up -d
```

**MongoDB connection error?**
```bash
docker-compose restart mongodb
docker-compose logs mongodb
```

## 📚 Full Documentation

See `README-DEPLOYMENT.md` for detailed instructions.
