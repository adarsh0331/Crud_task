# Deployment Checklist

Use this checklist to ensure all steps are completed correctly.

## 📋 Pre-Deployment Checklist

### Repository Setup
- [ ] GitHub repository created
- [ ] Code pushed to GitHub
- [ ] Repository is public or you have access configured

### Docker Hub Setup
- [ ] Docker Hub account created
- [ ] Docker Hub access token created
- [ ] Username and token noted

### VM Setup
- [ ] Ubuntu VM launched (AWS/Azure/GCP)
- [ ] VM public IP noted
- [ ] SSH access working
- [ ] Security group/firewall configured:
  - [ ] Port 22 (SSH) open
  - [ ] Port 80 (HTTP) open
- [ ] Docker installed on VM
- [ ] Docker Compose installed on VM
- [ ] User added to docker group

### SSH Key Setup
- [ ] SSH key pair generated for GitHub Actions
- [ ] Public key added to VM authorized_keys
- [ ] SSH connection tested
- [ ] Private key content copied (for GitHub secret)

### GitHub Secrets Configuration
- [ ] `DOCKER_HUB_USERNAME` added
- [ ] `DOCKER_HUB_TOKEN` added
- [ ] `VM_HOST` added (IP or domain)
- [ ] `VM_USER` added (usually `ubuntu`)
- [ ] `VM_SSH_KEY` added (private key content)

## 🚀 Deployment Checklist

### Initial Deployment
- [ ] Repository cloned on VM: `git clone <repo-url> mean-app`
- [ ] Navigated to project: `cd ~/mean-app`
- [ ] Docker Compose file reviewed
- [ ] Environment variables checked
- [ ] Application started: `docker-compose up -d`
- [ ] Containers running: `docker-compose ps`
- [ ] Logs checked: `docker-compose logs`

### Verification
- [ ] Application accessible: `http://<vm-ip>`
- [ ] Frontend loads correctly
- [ ] Backend API responds: `curl http://<vm-ip>/api/tutorials`
- [ ] Can create tutorial
- [ ] Can view tutorials
- [ ] Can search tutorials
- [ ] Can edit tutorial
- [ ] Can delete tutorial

### CI/CD Pipeline
- [ ] GitHub Actions workflow file exists
- [ ] Made test commit and push
- [ ] GitHub Actions workflow triggered
- [ ] Build step completed successfully
- [ ] Docker images pushed to Docker Hub
- [ ] Deployment step completed
- [ ] Application updated on VM automatically

## 🔧 Post-Deployment Checklist

### Monitoring
- [ ] Container logs reviewed
- [ ] No error messages in logs
- [ ] All services healthy
- [ ] MongoDB data persisting

### Security
- [ ] Only necessary ports open
- [ ] SSH key authentication working
- [ ] No passwords in code
- [ ] Secrets properly configured

### Documentation
- [ ] Deployment process documented
- [ ] Team members have access
- [ ] Troubleshooting guide reviewed

## 🐛 Troubleshooting Checklist

If something doesn't work:

- [ ] Checked container status: `docker-compose ps`
- [ ] Checked logs: `docker-compose logs -f`
- [ ] Verified network connectivity
- [ ] Checked firewall/security groups
- [ ] Verified environment variables
- [ ] Tested SSH connection
- [ ] Verified Docker Hub images exist
- [ ] Checked GitHub Actions logs

## 📊 Success Criteria

✅ Application is accessible on port 80
✅ All CRUD operations working
✅ CI/CD pipeline functional
✅ Automatic deployment working
✅ MongoDB data persisting
✅ No critical errors in logs

## 🎯 Next Steps (Optional)

- [ ] Set up domain name
- [ ] Configure SSL/HTTPS
- [ ] Set up monitoring
- [ ] Configure backups
- [ ] Set up logging aggregation
- [ ] Performance optimization
- [ ] Load balancing (if needed)

---

**Status**: ⬜ Not Started | 🟡 In Progress | ✅ Complete
