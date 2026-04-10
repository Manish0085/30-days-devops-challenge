# 🚀 Kubernetes Cluster Setup (AWS EC2) — Beginner Friendly Guide

## 📌 Overview

This guide helps you set up a **Kubernetes Cluster (1 Master + Worker Nodes)** on AWS EC2 **without facing common errors**.

👉 Based on real-world debugging:

* CRI issues fixed
* Network issues solved
* Correct repo usage
* Docker + cri-dockerd setup

---

# 🏗️ Architecture

```
1 Master Node (Control Plane)
1+ Worker Nodes
```

---

# ☁️ Step 1: Launch EC2 Instances

* Launch EC2 (Ubuntu 24.04)
* Minimum: t2.medium
* Open ports:

| Port | Purpose        |
| ---- | -------------- |
| 22   | SSH            |
| 6443 | Kubernetes API |

---

# ⚠️ Step 2: Disable Swap (ALL NODES)

```bash
sudo swapoff -a
sudo sed -i '/swap/d' /etc/fstab
```

---

# 🔧 Step 3: Enable Kernel Settings

```bash
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system
```

---

# 🐳 Step 4: Install Docker

```bash
sudo apt update
sudo apt install -y docker.io

sudo systemctl enable docker
sudo systemctl start docker
```

---

# ⚙️ Step 5: Configure Docker

```bash
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF

sudo systemctl restart docker
```

---

# 🔗 Step 6: Install cri-dockerd (IMPORTANT)

```bash
sudo apt install -y git golang-go

git clone https://github.com/Mirantis/cri-dockerd.git
cd cri-dockerd
mkdir bin
go build -o bin/cri-dockerd
sudo cp bin/cri-dockerd /usr/local/bin/
```

### Setup Service

```bash
sudo cp -a packaging/systemd/* /etc/systemd/system/
sudo sed -i 's:/usr/bin/cri-dockerd:/usr/local/bin/cri-dockerd:' /etc/systemd/system/cri-docker.service

sudo systemctl daemon-reexec
sudo systemctl daemon-reload

sudo systemctl enable cri-docker.service
sudo systemctl enable cri-docker.socket
sudo systemctl start cri-docker.socket
```

### Verify

```bash
ls /var/run/cri-dockerd.sock
```

---

# 📦 Step 7: Install Kubernetes

```bash
sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key \
| sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] \
https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /" \
| sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```

---

# 🚀 Step 8: Initialize Master Node

```bash
sudo kubeadm init \
--apiserver-advertise-address=<MASTER_PRIVATE_IP> \
--pod-network-cidr=10.244.0.0/16 \
--cri-socket=unix:///var/run/cri-dockerd.sock
```

---

# ⚙️ Step 9: Configure kubectl

```bash
mkdir -p $HOME/.kube
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

---

# 🌐 Step 10: Install Network (Flannel)

```bash
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
```

---

# 🔍 Step 11: Verify Master

```bash
kubectl get nodes
```

👉 First:

```
NotReady (normal)
```

👉 After 1–2 min:

```
Ready ✅
```

---

# 👷 Step 12: Worker Node Setup

👉 Repeat Steps 2 → 7 on worker nodes

---

# 🔗 Step 13: Join Worker Nodes

```bash
sudo kubeadm join <MASTER_IP>:6443 \
--token <TOKEN> \
--discovery-token-ca-cert-hash <HASH> \
--cri-socket=unix:///var/run/cri-dockerd.sock
```

---

# 🎯 Step 14: Verify Cluster

```bash
kubectl get nodes
```

Expected:

```
master   Ready
worker   Ready
```

---

# ❗ Common Errors & Fixes

## 🔴 Error: CRI socket not found

```bash
/var/run/cri-dockerd.sock not found
```

✅ Fix:

```bash
sudo systemctl restart cri-docker.socket
```

---

## 🔴 Error: API Server timeout

```bash
context deadline exceeded
```

✅ Fix:

* Open port **6443** in AWS Security Group

---

## 🔴 Error: bridge-nf-call-iptables missing

✅ Fix:

```bash
sudo modprobe br_netfilter
sudo sysctl --system
```

---

## 🔴 Node NotReady

✅ Fix:

* Install Flannel
* Wait 1–2 minutes

---

# 💯 Key Learnings

* Kubernetes setup = System + Network + Runtime
* Docker needs cri-dockerd
* AWS Security Group is critical
* Debugging is key skill in DevOps

---

# 🚀 Next Steps

* Deploy NGINX
* Deploy Spring Boot app
* Setup Ingress
* Add Monitoring

---

# 👨‍💻 Author

**Manish Kumar**
DevOps Learner | Java Backend Developer

---

# ⭐ Support

If this helped you:
👉 Star ⭐ this repo
👉 Share with others
👉 Keep learning 🚀
