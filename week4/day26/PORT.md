# 🚀 Kubernetes Pod Port Exposure (port.yml) — Complete Guide

## 📌 Overview

This guide explains how to **expose and test a container port inside a Kubernetes Pod**.

👉 You will learn:

* What `containerPort` means
* Why `curl localhost` fails
* How to properly access your application

---

# 📄 YAML File (port.yml)

```yaml
kind: Pod
apiVersion: v1
metadata:
  name: portexpose
  annotations:
    description: "This is an example of exposing port"
spec:
  containers:
    - name: c01
      image: httpd
      ports:
        - containerPort: 80
```

---

# 🧠 Concept: containerPort

👉 `containerPort` means:

* The port on which the container is listening internally
* It does **NOT expose the app outside the Pod**

❌ It does NOT:

* Open port on host machine
* Allow direct access via `localhost`

---

# 🚀 Step-by-Step Execution

---

## 🔹 1. Create YAML file

```bash
nano port.yml
```

---

## 🔹 2. Apply configuration

```bash
kubectl apply -f port.yml
```

👉 Output:

```
pod/portexpose created ✅
```

---

## 🔹 3. Check Pod

```bash
kubectl get pods
```

👉 Expected:

```
portexpose   1/1   Running ✅
```

---

# ❗ Common Mistake

```bash
curl localhost:80 ❌
```

👉 Why it fails?

* `localhost` refers to EC2 machine
* Pod runs in separate network
* No external exposure yet

---

# ✅ Correct Ways to Test

---

## 🔥 Method 1: Port Forward (Recommended)

```bash
kubectl port-forward pod/portexpose 8080:80
```

👉 Open browser:

```
http://localhost:8080
```

👉 Apache default page will appear 🔥

---

## 🔥 Method 2: Access inside Pod

```bash
kubectl exec -it portexpose -- /bin/bash
```

👉 Then:

```bash
curl localhost
```

---

## 🔥 Method 3: Expose via Service

```bash
kubectl expose pod portexpose --type=NodePort --port=80
minikube service portexpose
```

👉 Opens browser automatically

---

# ❗ Errors Faced & Fixes

---

## 🔴 Error: ImagePullBackOff

👉 Cause:

```yaml
image: apache ❌
```

✅ Fix:

```yaml
image: httpd ✔️
```

---

## 🔴 Error: ports syntax

❌ Wrong:

```yaml
ports:
  containerPort: 80
```

✅ Correct:

```yaml
ports:
  - containerPort: 80
```

---

# 💯 Key Learnings

* `containerPort` is informational
* Pods are isolated from host network
* Use port-forward or service for access
* Image name must be valid

---

# 🚀 Next Steps

* Create Service (NodePort / ClusterIP)
* Deploy using Deployment
* Setup Ingress

---

# 👨‍💻 Author

**Manish Kumar**
DevOps Learner 🚀

---

# ⭐ Support

If this helped:

* ⭐ Star repo
* Share with others
* Keep learning Kubernetes 🔥
