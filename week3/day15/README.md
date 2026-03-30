# Day 15 — Jenkins Setup on AWS EC2 (Ubuntu 24.04) 🚀

## Prerequisites

- AWS EC2 instance running Ubuntu 24.04
- Java 17+ installed
- Security Group with port 8080 open
- Root or sudo access

---

## Step 1 — Install Java (if not installed)

```bash
sudo apt update -y
sudo apt install openjdk-17-jdk -y

# Verify
java -version
```

---

## Step 2 — Add Jenkins Repository

```bash
# Download Jenkins GPG key
wget -O /tmp/jenkins.key https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

# Convert and save key
sudo gpg --yes --dearmor -o /etc/apt/keyrings/jenkins.gpg /tmp/jenkins.key

# Add Jenkins repo to apt sources
echo "deb [signed-by=/etc/apt/keyrings/jenkins.gpg trusted=yes] https://pkg.jenkins.io/debian-stable binary/" | \
    sudo tee /etc/apt/sources.list.d/jenkins.list
```

---

## Step 3 — Install Jenkins

```bash
sudo apt update -y
sudo apt install jenkins -y --allow-unauthenticated
```

---

## Step 4 — Start Jenkins

```bash
# Start Jenkins service
sudo systemctl start jenkins

# Enable Jenkins to start on reboot
sudo systemctl enable jenkins

# Check status
sudo systemctl status jenkins
```

Expected output:
```
Active: active (running) ✓
Jenkins is fully up and running ✓
```

---

## Step 5 — Open Port 8080 on AWS

```bash
# Replace with your Security Group ID
aws ec2 authorize-security-group-ingress \
    --group-id YOUR_SECURITY_GROUP_ID \
    --protocol tcp \
    --port 8080 \
    --cidr 0.0.0.0/0
```

---

## Step 6 — Access Jenkins in Browser

```
http://YOUR_EC2_PUBLIC_IP:8080
```

---

## Step 7 — Initial Setup

**Get Admin Password:**
```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

**Setup Wizard Steps:**
1. Paste the admin password
2. Click "Install suggested plugins" — wait for installation
3. Create first admin user
4. Set Jenkins URL — keep default
5. Click "Start using Jenkins"

---

## Useful Jenkins Commands

```bash
# Start Jenkins
sudo systemctl start jenkins

# Stop Jenkins
sudo systemctl stop jenkins

# Restart Jenkins
sudo systemctl restart jenkins

# Check status
sudo systemctl status jenkins

# View Jenkins logs
sudo journalctl -u jenkins -f

# Get initial admin password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

---

## Jenkins File Locations

| File | Location |
|------|----------|
| Jenkins home | `/var/lib/jenkins` |
| Jenkins logs | `/var/log/jenkins` |
| Jenkins config | `/var/lib/jenkins/config.xml` |
| Admin password | `/var/lib/jenkins/secrets/initialAdminPassword` |
| Jobs | `/var/lib/jenkins/jobs` |

---

## Troubleshooting

**Jenkins not starting:**
```bash
sudo journalctl -u jenkins -n 50
```

**Port 8080 not accessible:**
```bash
# Check if Jenkins is listening
sudo netstat -tlnp | grep 8080

# Check Security Group rules
aws ec2 describe-security-groups --group-ids YOUR_SG_ID
```

**GPG key error during apt update:**
```bash
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 7198F4B714ABFC68
sudo apt update -y
```

**Java not found:**
```bash
export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))
echo $JAVA_HOME
```

---

## Week 3 Plan

```
Day 15 ✓ — Jenkins install + setup
Day 16   — First Jenkins job
Day 17   — GitHub + Jenkins webhook
Day 18   — Jenkinsfile — Pipeline as Code
Day 19   — Docker build + push pipeline
Day 20   — Auto deploy to EC2
Day 21   — Complete CI/CD Pipeline
```

---

> Built as part of 30 Days DevOps Challenge
> GitHub: https://github.com/Manish0085/30-days-devops-challenge
