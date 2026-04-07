# Day 23 — Kubernetes Setup (Minikube + kubectl) on EC2

## What I Did Today
- Wrote `k8s_setup.sh` — automated Minikube + kubectl installation script
- Installed kubectl and Minikube on EC2
- Fixed Docker permissions for ubuntu user
- Started first Kubernetes cluster on EC2
- Verified cluster with `kubectl get nodes`

---

## Setup Flow
```
EC2 (t2.medium — 2 CPU, 4GB RAM)
        ↓
Docker install karo
        ↓
kubectl install karo
        ↓
Minikube install karo
        ↓
minikube start --driver=docker
        ↓
kubectl get nodes → Ready ✓
```

---

## Commands Used

### System Requirements Check
```bash
# CPU count check
nproc

# RAM check
free -g | grep Mem | awk '{print $2}'

# Docker check
docker --version
```

### kubectl Install
```bash
# Latest version download karo
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Install karo
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Cleanup
rm kubectl

# Verify
kubectl version --client
```

### Minikube Install
```bash
# Download karo
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

# Install karo
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Cleanup
rm minikube-linux-amd64

# Verify
minikube version
```

### Docker Permissions Fix
```bash
# Ubuntu user ko docker group mein add karo
sudo usermod -aG docker $USER

# Group reload karo
newgrp docker
```

### Minikube Start
```bash
minikube start --driver=docker
```

### Verify Cluster
```bash
# Nodes check karo
kubectl get nodes

# Cluster info
kubectl cluster-info

# Pods check karo
kubectl get pods
```

### Minikube Stop
```bash
minikube stop
```

---

## Cluster Output
```
NAME       STATUS   ROLES           AGE   VERSION
minikube   Ready    control-plane   51s   v1.35.1
```

---

## Errors Fixed

| Error | Cause | Fix |
|-------|-------|-----|
| DRV_AS_ROOT | Minikube root se start kiya | ubuntu user se start kiya |
| Permission denied docker.sock | ubuntu user docker group mein nahi tha | `sudo usermod -aG docker $USER && newgrp docker` |
| Memory warning | Total RAM 3814MB, Minikube ko 3072MB chahiye | Warning ignore kiya — t2.medium pe chala |

---

## Concepts Learned

| Concept | Description |
|--------|-------------|
| Minikube | Local K8s cluster — learning aur testing ke liye |
| kubectl | K8s ka CLI tool — jaise docker CLI tha Docker ke liye |
| --driver=docker | Minikube Docker container ke andar K8s run karta hai |
| kubectl get nodes | Cluster ke nodes ka status dekhna |
| kubectl get pods | Running pods dekhna |
| control-plane | Master node — cluster manage karta hai |

---

## K8s Setup Script
```
k8s_setup.sh
  ├── check_requirements()  — CPU, RAM, Docker check
  ├── install_kubectl()     — kubectl download + install
  ├── install_minikube()    — minikube download + install
  ├── start_minikube()      — minikube start with docker driver
  └── verify_setup()        — kubectl get nodes + cluster-info
```
