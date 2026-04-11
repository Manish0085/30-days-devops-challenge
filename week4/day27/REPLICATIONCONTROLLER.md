# 🚀 Kubernetes Replication Controller — Complete Guide

## 📌 Overview

This guide explains how to use a **Replication Controller (RC)** in Kubernetes.

👉 Replication Controller ensures:

* A specified number of Pods are always running
* If a Pod crashes → it automatically creates a new one
* Helps maintain **high availability**

---

# 📄 YAML File (replicaController.yml)

```yaml
kind: ReplicationController
apiVersion: v1
metadata:
  name: replicacontrollerpod
  annotations:
    description: This is the demo for the replication controller

spec:
  replicas: 3

  selector:
    myname: replicacontroller

  template:
    metadata:
      name: replicacontrollerpod
      labels:
        myname: replicacontroller

    spec:
      containers:
        - name: c01
          image: ubuntu
          command:
            - "/bin/bash"
            - "-c"
            - "while true; do echo Replication Controller; sleep 5; done"
```

---

# 🧠 YAML Explanation (Line by Line)

---

## 🔹 kind & apiVersion

```yaml
kind: ReplicationController
apiVersion: v1
```

👉 Defines:

* Resource type = ReplicationController
* API version = v1

---

## 🔹 metadata

```yaml
metadata:
  name: replicacontrollerpod
  annotations:
    description: This is the demo for the replication controller
```

👉 Contains:

* Name of RC
* Extra info using annotations

---

## 🔹 spec (Main Logic)

```yaml
spec:
```

👉 Defines desired state

---

## 🔹 replicas

```yaml
replicas: 3
```

👉 Kubernetes will:

* Maintain **3 Pods always running**

---

## 🔹 selector

```yaml
selector:
  myname: replicacontroller
```

👉 RC manages Pods having:

```yaml
myname=replicacontroller
```

👉 Important:

* Selector must match template labels

---

## 🔹 template

```yaml
template:
```

👉 Blueprint for Pods

---

## 🔹 template.metadata.labels

```yaml
labels:
  myname: replicacontroller
```

👉 Labels assigned to Pods
👉 Must match selector

---

## 🔹 containers

```yaml
containers:
  - name: c01
    image: ubuntu
```

👉 Defines container details

---

## 🔹 command

```yaml
command:
  - "/bin/bash"
  - "-c"
  - "while true; do echo Replication Controller; sleep 5; done"
```

👉 Runs infinite loop:

* Keeps container alive
* Prevents crash

---

# 🚀 Step-by-Step Execution

---

## 🔹 1. Apply YAML

```bash
kubectl apply -f replicaController.yml
```

👉 Output:

```
replicationcontroller/replicacontrollerpod created
```

---

## 🔹 2. Check RC

```bash
kubectl get rc
```

👉 Output:

```
DESIRED   CURRENT   READY
3         3         3
```

---

## 🔹 3. Check Pods

```bash
kubectl get pods
```

👉 3 Pods running ✔️

---

# 🔥 Self-Healing Feature

👉 Delete a Pod:

```bash
kubectl delete pod <pod-name>
```

👉 Result:

* New Pod automatically created 🔥

---

# 📈 Scaling

---

## 🔹 Scale Up

```bash
kubectl scale --replicas=5 rc -l myname=replicacontroller
```

👉 Pods increase to 5

---

## 🔹 Scale Down

```bash
kubectl scale --replicas=2 rc -l myname=replicacontroller
```

👉 Extra Pods terminated

---

# 🔍 Verify RC

```bash
kubectl describe rc replicacontrollerpod
```

👉 Shows:

* Pods managed
* Events
* Labels

---

# ❗ Errors Faced & Fixes

---

## 🔴 Error: wrong scale command

❌ Wrong:

```bash
kubectl scale replicas=5 rc
```

✅ Correct:

```bash
kubectl scale --replicas=5 rc
```

---

## 🔴 Error: selector mismatch

👉 If labels ≠ selector
👉 RC will not manage Pods

---

## 🔴 Error: container exits

👉 Fix:

* Use infinite loop

---

# 💯 Key Learnings

* RC maintains desired number of Pods
* Automatically replaces failed Pods
* Uses labels & selectors
* Supports scaling
* Basic concept behind Deployments

---

# 🚀 Important Note

👉 ReplicationController is **old concept**

👉 Modern Kubernetes uses:

* **ReplicaSet**
* **Deployment** (recommended)

---

# 🔥 Real Use Cases

* Maintain uptime
* Auto-recovery
* Load distribution
* Horizontal scaling

---

# 📌 Commands Summary

```bash
# Apply
kubectl apply -f replicaController.yml

# Get RC
kubectl get rc

# Get Pods
kubectl get pods

# Scale
kubectl scale --replicas=5 rc -l myname=replicacontroller

# Describe
kubectl describe rc replicacontrollerpod
```

---

# 👨‍💻 Author

**Manish Kumar**
DevOps Learner 🚀

---

# ⭐ Support

If this helped:

* ⭐ Star the repo
* Share with others
* Keep learning Kubernetes 🔥
