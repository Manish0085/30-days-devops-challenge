# 🚀 Kubernetes Multi-Container Pod — Communication Demo (pod2.yml)

## 📌 Overview

This README explains how to create a **Multi-Container Pod** in Kubernetes and how containers inside the same pod communicate with each other.

👉 In Kubernetes:

* Multiple containers in the same Pod share:

  * Network (same IP, same localhost)
  * Storage (if volumes are used)

---

# 📄 YAML File (pod2.yml)

```yaml
kind: Pod
apiVersion: v1

metadata:
  name: nodepod
  annotations:
    description: Communication between two containers inside same pod

spec:
  containers:
    - name: c01
      image: ubuntu
      command:
        - "/bin/bash"
        - "-c"
        - "while true; do echo Communication between containers; sleep 5; done"

    - name: c02
      image: httpd
      ports:
        - containerPort: 80
```

---

# 🧠 YAML Explanation (Line-by-Line)

---

## 🔹 kind & apiVersion

```yaml
kind: Pod
apiVersion: v1
```

👉 Defines a basic Kubernetes Pod

---

## 🔹 metadata

```yaml
name: nodepod
```

👉 Name of the Pod

---

## 🔹 annotations

```yaml
description: Communication between two containers inside same pod
```

👉 Informational metadata

---

## 🔹 containers

👉 Pod contains **2 containers**:

---

### 🔸 Container 1 (c01)

```yaml
name: c01
image: ubuntu
```

👉 Runs Ubuntu container

```yaml
command: while true...
```

👉 Keeps container running continuously

---

### 🔸 Container 2 (c02)

```yaml
name: c02
image: httpd
```

👉 Runs Apache HTTP Server

```yaml
ports:
  - containerPort: 80
```

👉 Exposes port 80 inside the container

---

# 🔥 Key Concept: Shared Network

👉 Both containers share:

```bash
localhost (127.0.0.1)
```

✔️ Means:

* c01 can access c02 using `localhost:80`

---

# 🚀 Step-by-Step Execution

---

## 🔹 1. Create Pod

```bash
kubectl apply -f pod2.yml
```

---

## 🔹 2. Verify Pod

```bash
kubectl get pods -o wide
```

👉 Output reference: 

---

## 🔹 3. Enter Container (c01)

```bash
kubectl exec -it nodepod -c c01 -- /bin/bash
```

---

## 🔹 4. Install curl (inside container)

```bash
apt update && apt install curl -y
```

---

## 🔹 5. Test Communication

```bash
curl localhost:80
```

👉 Output:

```html
It works! Apache httpd
```

✔️ This proves:
👉 c01 successfully accessed c02 using localhost

---

# 🔄 Architecture

```
Pod (nodepod)
 ├── Container c01 (Ubuntu)
 └── Container c02 (Apache HTTP Server)
        ↑
        | (via localhost)
        ↓
   Communication works
```

---

# 💥 Important Learnings

---

## 🔹 1. Same Pod = Same Network

👉 Containers inside a Pod share:

* Same IP
* Same localhost

---

## 🔹 2. No Service Required

👉 Internal communication does NOT need:

* Service ❌
* DNS ❌

---

## 🔹 3. Use Cases

* Sidecar containers
* Logging agents
* Monitoring tools
* Reverse proxy (NGINX + App)

---

# ⚠️ Common Issues (From Your Practice)

---

## ❌ curl not found

```bash
curl: command not found
```

👉 Fix:

```bash
apt install curl -y
```

---

## ❌ Wrong exec command

```bash
kubectl exec -it nodepod -c c01 ❌
```

👉 Fix:

```bash
kubectl exec -it nodepod -c c01 -- /bin/bash ✅
```

---

## ❌ Trying localhost in terminal directly

```bash
localhost:80 ❌
```

👉 Fix:

```bash
curl localhost:80 ✅
```

---

# 💯 Key Takeaways

* Multi-container Pod enables tight coupling
* Containers communicate using `localhost`
* Ideal for sidecar pattern
* No networking complexity inside Pod

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
