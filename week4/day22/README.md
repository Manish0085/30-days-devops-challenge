# 🚀 Day 22 — Kubernetes Introduction

## 📌 Overview

Today I started learning **Kubernetes (K8s)** — the most widely used container orchestration platform for managing applications at scale.

After working with Docker, I explored why containerization alone is not enough in real-world production environments and how Kubernetes solves those challenges.

---

## ❓ Why Kubernetes?

Docker helps in packaging and running applications inside containers.  
However, in production systems, managing containers introduces several challenges:

- Containers can crash, leading to application downtime  
- A single container cannot handle traffic spikes  
- Deploying new versions can cause downtime  
- Managing containers across multiple machines becomes complex  

Kubernetes is designed to solve these problems by automating container management.

---

## ⚙️ What Kubernetes Does

Kubernetes provides a system to:

- **Automatically restart** failed containers (Self-healing)  
- **Scale applications** based on demand (Auto-scaling)  
- **Deploy updates without downtime** (Rolling updates)  
- **Distribute traffic efficiently** (Load balancing)  

It ensures that the application is always running in the **desired state**.

---

## 🧠 Core Concept: Desired State

Kubernetes follows a **declarative model**.

Instead of manually managing containers, you define:

> "How your system should look"

Example:
- 3 instances of an application should always be running  

Kubernetes continuously monitors and ensures that this state is maintained.

---

## 🏗️ Kubernetes Architecture

A Kubernetes cluster consists of:

### 🔹 Control Plane (Brain)
Responsible for managing the cluster:

- **API Server** — entry point for all commands  
- **etcd** — stores cluster data  
- **Scheduler** — assigns pods to nodes  
- **Controller Manager** — ensures desired state  

### 🔹 Worker Nodes
Machines where applications actually run:

- **Kubelet** — communicates with control plane  
- **Container Runtime** — runs containers (Docker/containerd)  
- **Kube-proxy** — handles networking  

---

## 📦 Key Kubernetes Components

### 🔸 Pod
- Smallest deployable unit  
- Contains one or more containers  
- Shares network and storage  

### 🔸 Node
- A machine (VM or physical) where pods run  

### 🔸 Cluster
- Group of nodes managed by Kubernetes  

### 🔸 Deployment
- Manages pods and ensures desired number of replicas  
- Handles updates and rollbacks  

### 🔸 Service
- Provides a stable way to access pods  
- Enables load balancing  

---

## 🔄 Docker vs Kubernetes

| Docker | Kubernetes |
|------|-----------|
| Runs containers | Manages containers at scale |
| Manual operations | Automated system |
| Single machine focus | Distributed system |
| No self-healing | Self-healing & scaling |

---

## 🧠 Key Takeaway

- Docker solves **containerization**  
- Kubernetes solves **container orchestration**  

Kubernetes is not just about running containers —  
it is about **managing, scaling, and maintaining applications in production environments**.

---

## 📈 Next Steps

- Set up Minikube  
- Deploy first application  
- Understand scaling and rolling updates  

---

> Learning DevOps step by step. 🚀
