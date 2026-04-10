# 🚀 Kubernetes Pod Creation (pod1.yml) — Complete Guide

## 📌 Overview

This guide explains how to create and manage a **basic Kubernetes Pod** using a YAML file.

👉 Includes:

* YAML explanation
* Commands used
* Errors faced & fixes
* Logs & debugging

---

# 📄 Pod YAML File (pod1.yml)

```yaml
kind: Pod
apiVersion: v1
metadata:
  name: testpod
spec:
  containers:
    - name: c00
      image: ubuntu
      command: ["/bin/bash", "-c", "while true; do echo Devops learner; sleep 5; done"]
  restartPolicy: Never
```

---

# 🧠 YAML Explanation

### 🔹 kind: Pod

👉 Defines that we are creating a **Pod**

### 🔹 apiVersion: v1

👉 Uses Kubernetes core API version

### 🔹 metadata.name: testpod

👉 Name of the pod
⚠️ Must be lowercase (important rule)

---

### 🔹 spec.containers

👉 Defines container inside pod

| Field   | Meaning               |
| ------- | --------------------- |
| name    | Container name        |
| image   | Docker image (ubuntu) |
| command | Custom command to run |

---

### 🔹 Command Explanation

```bash
while true; do echo Devops learner; sleep 5; done
```

👉 Infinite loop:

* prints "Devops learner"
* waits 5 seconds
* repeats forever

---

### 🔹 restartPolicy: Never

👉 Pod will NOT restart if it stops

---

# 🚀 Step-by-Step Commands

---

## 🔹 1. Create YAML file

```bash
nano pod1.yml
```

👉 Paste the YAML content

---

## 🔹 2. Apply configuration

```bash
kubectl apply -f pod1.yml
```

👉 Creates the pod in cluster

---

## 🔹 3. Check pods

```bash
kubectl get pods
```

👉 Output:

```
testpod   Running ✅
```

---

## 🔹 4. Detailed info

```bash
kubectl describe pod testpod
```

👉 Shows:

* IP
* Node
* Events
* Container details

---

## 🔹 5. Get logs

```bash
kubectl logs testpod
```

👉 Output:

```
Devops learner
Devops learner
```

---

## 🔹 6. Logs for specific container

```bash
kubectl logs testpod -c c00
```

---

## 🔹 7. Delete pod

```bash
kubectl delete pod testpod
```

---

# ❗ Errors Faced & Fixes

---

## 🔴 Error 1: Invalid Pod Name

```bash
Invalid value: "testPod"
```

❌ Problem:

* Uppercase letter used

✅ Fix:

```yaml
name: testpod
```

---

## 🔴 Error 2: Wrong logs command

```bash
kubectl logs pod testpod ❌
kubectl logs pods testpod ❌
```

✅ Correct:

```bash
kubectl logs testpod
```

---

## 🔴 Error 3: Wrong container name

```bash
kubectl logs testpod -c c01 ❌
```

❌ Problem:

* Container name doesn't exist

✅ Fix:

```bash
kubectl logs testpod -c c00
```

---

# 🔍 Output Evidence

👉 Pod successfully running and printing logs:


---

# 💯 Key Learnings

* Pod names must be lowercase (RFC rules)
* YAML is used to define Kubernetes objects
* Logs help debug containers
* `kubectl describe` is powerful tool

---

# 🚀 Next Steps

* Create Deployment instead of Pod
* Scale applications
* Use Services
* Learn ConfigMaps & Secrets

---

# 👨‍💻 Author

**Manish Kumar**
DevOps Learner 🚀

---

# ⭐ Support

If this helped:

* ⭐ Star repo
* Share with others
* Practice more Kubernetes 🔥
