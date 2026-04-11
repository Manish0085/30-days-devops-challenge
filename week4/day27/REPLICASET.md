# 🚀 Kubernetes ReplicaSet (replicaSet.yml) — Complete Guide

## 📌 Overview

This guide explains how to use a **ReplicaSet** in Kubernetes.

👉 ReplicaSet ensures:

* A fixed number of Pods are always running
* Self-healing (recreates failed Pods)
* Supports advanced label selectors

---

# 📄 YAML File (replicaSet.yml)

```yaml
kind: ReplicaSet
apiVersion: apps/v1

metadata:
  name: myrs

spec:
  replicas: 2

  selector:
    matchExpressions:
      - key: myname
        operator: In
        values:
          - developer
          - devops
      - key: env
        operator: NotIn
        values:
          - production

  template:
    metadata:
      labels:
        myname: developer
        env: development

    spec:
      containers:
        - name: c00
          image: ubuntu
          command:
            - /bin/bash
            - -c
            - while true; do echo Technical-Guftgu; sleep 5; done
```

---

# 🧠 YAML Explanation (Line by Line)

---

## 🔹 kind & apiVersion

```yaml
kind: ReplicaSet
apiVersion: apps/v1
```

👉 Defines resource type = ReplicaSet
👉 Uses modern API (apps/v1)

---

## 🔹 metadata

```yaml
metadata:
  name: myrs
```

👉 Name of ReplicaSet

---

## 🔹 replicas

```yaml
replicas: 2
```

👉 Desired number of Pods = 2

---

## 🔹 selector (Advanced)

```yaml
selector:
  matchExpressions:
```

👉 Used to select Pods dynamically

---

### 🔸 matchExpressions

```yaml
- key: myname
  operator: In
  values:
    - developer
    - devops
```

👉 Pod must have:

* myname = developer OR devops

---

```yaml
- key: env
  operator: NotIn
  values:
    - production
```

👉 Pod must NOT have:

* env = production

---

## 🔹 template

👉 Blueprint of Pods

---

## 🔹 template.metadata.labels

```yaml
labels:
  myname: developer
  env: development
```

👉 Must match selector conditions ✔️

---

## 🔹 containers

```yaml
containers:
  - name: c00
    image: ubuntu
```

👉 Defines container

---

## 🔹 command

```yaml
while true; do echo Technical-Guftgu; sleep 5; done
```

👉 Keeps container running (prevents crash)

---

# 🚀 Step-by-Step Execution

---

## 🔹 1. Apply YAML

```bash
kubectl apply -f replicaSet.yml
```

---

## 🔹 2. Check ReplicaSet

```bash
kubectl get rs
```

👉 Output:

```
myrs   2   2   2
```

---

## 🔹 3. Check Pods

```bash
kubectl get pods
```

👉 2 Pods running ✔️

---

# 🔥 Self-Healing Demo

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
kubectl scale rs myrs --replicas=5
```

---

## 🔹 Scale Down

```bash
kubectl scale rs myrs --replicas=2
```

---

# ❗ Important Concept

👉 ReplicaSet labels vs Pod labels

| Resource   | Labels              |
| ---------- | ------------------- |
| ReplicaSet | ❌ (none by default) |
| Pod        | ✔️ (from template)  |

👉 That’s why:

```bash
kubectl scale rs -l myname=developer ❌
```

👉 Fails because RS has no such label

---

# ✅ Correct Way

```bash
kubectl scale rs myrs --replicas=5 ✔️
```

---

# ❗ Errors Faced & Fixes

---

## 🔴 YAML Parsing Error

👉 Cause:

* Bad indentation
* Inline `{}` syntax
* Hidden characters

👉 Fix:

* Use proper YAML format
* Use spaces (not tabs)

---

## 🔴 Selector mismatch

👉 If selector ≠ labels
👉 Pods won’t be created

---

## 🔴 Container Crash

👉 Fix:

* Use infinite loop

---

# 💯 Key Learnings

* ReplicaSet maintains desired Pod count
* Uses advanced selectors
* Self-healing capability
* Base for Deployment
* Labels must match selector

---

# 🚀 Difference: RC vs ReplicaSet

| Feature            | RC     | ReplicaSet  |
| ------------------ | ------ | ----------- |
| Selector           | simple | advanced ✔️ |
| Modern             | ❌      | ✔️          |
| Used in Deployment | ❌      | ✔️          |

---

# 🚀 Next Steps

* Learn **Deployment (most important)**
* Rolling updates
* Zero downtime deployments

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
