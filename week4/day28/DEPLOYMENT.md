# 🚀 Kubernetes Deployment — Complete Guide (deployment.yml)

## 📌 Overview

This README explains how to create and manage a **Deployment in Kubernetes**.

👉 Deployment is the **most important object in Kubernetes** because it:

* Manages Pods using ReplicaSet
* Supports scaling
* Enables rolling updates
* Allows rollback to previous versions

---

# 📄 Deployment YAML (deployment.yml)

```yaml
kind: Deployment
apiVersion: apps/v1

metadata:
  name: deploymentpod
  annotations:
    description: This is an example of the deployment

spec:
  replicas: 2

  selector:
    matchLabels:
      name: deployment

  template:
    metadata:
      name: testpod
      labels:
        name: deployment

    spec:
      containers:
        - name: c01
          image: ubuntu
          command:
            - "/bin/bash"
            - "-c"
            - "while true; do echo Deployment example; sleep 5; done"
```

---

# 🧠 YAML Explanation (Line-by-Line)

---

## 🔹 kind & apiVersion

```yaml
kind: Deployment
apiVersion: apps/v1
```

👉 Defines resource type = Deployment
👉 Uses stable API (`apps/v1`)

---

## 🔹 metadata

```yaml
metadata:
  name: deploymentpod
```

👉 Name of Deployment

---

## 🔹 annotations

```yaml
annotations:
  description: This is an example of the deployment
```

👉 Extra info (not used by Kubernetes internally, just for humans)

---

## 🔹 replicas

```yaml
replicas: 2
```

👉 Number of Pods to run

---

## 🔹 selector

```yaml
selector:
  matchLabels:
    name: deployment
```

👉 Selects Pods managed by Deployment
👉 MUST match Pod labels

---

## 🔹 template

👉 Blueprint for Pods

---

## 🔹 template.metadata.labels

```yaml
labels:
  name: deployment
```

👉 Must match selector ✔️

---

## 🔹 containers

```yaml
containers:
  - name: c01
    image: ubuntu
```

👉 Defines container

---

## 🔹 command

```yaml
while true; do echo Deployment example; sleep 5; done
```

👉 Keeps container running

---

# 🚀 Step-by-Step Execution

---

## 🔹 1. Apply Deployment

```bash
kubectl apply -f deployment.yml
```

---

## 🔹 2. Verify Deployment

```bash
kubectl get deploy
```

---

## 🔹 3. Check ReplicaSet

```bash
kubectl get rs
```

---

## 🔹 4. Check Pods

```bash
kubectl get pods
```

---

# 🔄 Architecture Flow

```
Deployment → ReplicaSet → Pods
```

👉 Deployment manages ReplicaSet
👉 ReplicaSet manages Pods

---

# 🔥 Scaling

---

## 🔹 Scale Up

```bash
kubectl scale deployment deploymentpod --replicas=5
```

---

## 🔹 Scale Down

```bash
kubectl scale deployment deploymentpod --replicas=2
```

---

# 🔁 Rolling Update (Update Deployment)

👉 Change YAML (e.g., command/message)

```bash
kubectl apply -f deployment.yml
```

👉 Check rollout:

```bash
kubectl rollout status deployment deploymentpod
```

---

# 📜 Rollout History

```bash
kubectl rollout history deployment deploymentpod
```

---

# ⏪ Rollback

```bash
kubectl rollout undo deployment deploymentpod
```

👉 Reverts to previous version

---

# 💥 Self-Healing Demo

👉 Delete a Pod:

```bash
kubectl delete pod <pod-name>
```

👉 Result:

* New Pod automatically created ✔️

---

# ❗ Common Errors (From Your Practice)

---

## 🔴 Error: wrong apiVersion

```yaml
apiVersion: app/v1 ❌
```

👉 Fix:

```yaml
apiVersion: apps/v1 ✅
```

---

## 🔴 Error: selector mismatch

👉 selector ≠ labels → Pods won’t be created

---

## 🔴 Error: wrong command

```bash
kubectl get deployment.yml ❌
```

👉 Fix:

```bash
kubectl get deploy ✅
```

---

## 🔴 Error: typo in command

```bash
kubectl rollout status deployemnt ❌
```

👉 Fix:

```bash
kubectl rollout status deployment deploymentpod ✅
```

---

# 💯 Key Learnings

* Deployment is used in real-world production
* Supports rolling updates & rollback
* Provides high availability
* Automatically manages ReplicaSets
* Ensures desired state

---

# 🚀 Real Example from Practice

👉 You observed:

* New ReplicaSet created on update ✔️
* Old ReplicaSet scaled down ✔️
* Pods recreated automatically ✔️
* Rollback worked perfectly ✔️

📄 Logs & commands reference: 

---

# 🔥 Difference: ReplicaSet vs Deployment

| Feature            | ReplicaSet | Deployment |
| ------------------ | ---------- | ---------- |
| Self-healing       | ✔️         | ✔️         |
| Scaling            | ✔️         | ✔️         |
| Rolling Update     | ❌          | ✔️         |
| Rollback           | ❌          | ✔️         |
| Used in Production | ❌          | ✔️         |

---

# 🚀 Next Steps

* Services (ClusterIP, NodePort)
* Exposing applications
* Ingress

---

# 👨‍💻 Author

**Manish Kumar**
DevOps Learner 🚀

---

# ⭐ Support

If this helped:

* ⭐ Star the repo
* Share with others
* Keep learning Kubernetes 💯🔥
