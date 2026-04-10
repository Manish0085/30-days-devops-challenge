# 🚀 Minikube Setup Guide (Step-by-Step) — Beginner Friendly

## 📌 Overview

This guide helps you set up a **Kubernetes cluster locally using Minikube** in the simplest and error-free way.

👉 Ideal for:

* Beginners learning Kubernetes
* Local testing & development
* Practicing deployments

---

# 🧠 What is Minikube?

Minikube is a tool that lets you run a **single-node Kubernetes cluster** on your local machine or VM.

✔️ No need for AWS
✔️ No multi-node complexity
✔️ Everything runs locally using Docker

---

# ⚙️ Prerequisites

* Ubuntu / Linux system
* At least:

  * 2 CPUs
  * 2GB RAM
* Internet connection

---

# 🧹 Step 1: Update System

```bash
sudo apt update && sudo apt upgrade -y
```

👉 Updates all system packages to latest versions

---

# 🐳 Step 2: Install Docker

```bash
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
```

👉 Docker is used as the container runtime for Minikube

---

# 🔐 Step 3: Fix Docker Permissions

```bash
sudo usermod -aG docker $USER
newgrp docker
```

👉 Allows running Docker without `sudo`

---

# 🔧 Step 4: Install kubectl

```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

sudo install kubectl /usr/local/bin/
```

👉 `kubectl` is the CLI tool to interact with Kubernetes

---

# 🔍 Verify kubectl

```bash
kubectl version --client
```

---

# 🚀 Step 5: Install Minikube

```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

👉 Installs Minikube binary

---

# 🔍 Verify Minikube

```bash
minikube version
```

---

# ▶️ Step 6: Start Minikube Cluster

```bash
minikube start --driver=docker
```

👉 This command:

* Creates a Kubernetes cluster
* Uses Docker as backend
* Sets up control plane automatically

---

# 🔍 Step 7: Check Cluster Status

```bash
kubectl get nodes
```

👉 Expected output:

```
minikube   Ready
```

---

# 📦 Step 8: Deploy an Application

```bash
kubectl create deployment nginx --image=nginx
```

👉 Creates a deployment using NGINX container

---

# 🌐 Step 9: Expose the Application

```bash
kubectl expose deployment nginx --type=NodePort --port=80
```

👉 Makes the app accessible outside the cluster

---

# 🌍 Step 10: Access Application

```bash
minikube service nginx
```

👉 Opens the service in your browser

---

# 🔍 Check Pods

```bash
kubectl get pods
```

👉 Shows running containers in the cluster

---

# 🔄 Useful Commands

## Stop Minikube

```bash
minikube stop
```

👉 Stops the cluster (saves resources)

---

## Start Again

```bash
minikube start
```

👉 Restarts the cluster

---

## Delete Cluster

```bash
minikube delete
```

👉 Completely removes the cluster

---

# ❗ Common Errors & Fixes

---

## 🔴 Error: Docker permission denied

```bash
permission denied while connecting to docker.sock
```

✅ Fix:

```bash
sudo usermod -aG docker $USER
newgrp docker
```

---

## 🔴 Error: Driver as root

```bash
docker driver should not be used with root
```

✅ Fix:

* Run Minikube as normal user (not root)

---

## 🔴 kubectl connection refused

```bash
localhost:8080 refused
```

✅ Fix:

* Ensure Minikube is running

---

# 💯 Key Learnings

* Kubernetes basics become easy with Minikube
* No need for cloud infrastructure
* Best tool for beginners

---

# 🚀 Next Steps

* Deploy Spring Boot app
* Learn scaling & rolling updates
* Use ConfigMaps & Secrets
* Setup Ingress

---

# 👨‍💻 Author

**Manish Kumar**
DevOps Learner 🚀

---

# ⭐ Support

If this helped you:

* ⭐ Star this repo
* Share with others
* Keep learning Kubernetes 🔥
