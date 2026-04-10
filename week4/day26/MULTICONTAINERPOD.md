# 🚀 Kubernetes Multi-Container Pod (multiContainer.yml) — Complete Guide

## 📌 Overview

This guide explains how to create a **Multi-Container Pod** in Kubernetes.

👉 A single Pod can contain **multiple containers** that:

* Run together
* Share network & storage
* Work as a single unit

---

# 📄 YAML File (multiContainer.yml)

```yaml
kind: Pod
apiVersion: v1
metadata:
  name: multicontainerpod
  annotations:
    description: "This pod contains multiple containers"
spec:
  containers:
    - name: c01
      image: ubuntu
      command: ["/bin/bash", "-c", "echo Container1"]
    - name: c02
      image: ubuntu
      command: ["/bin/bash", "-c", "echo Container2"]
    - name: c03
      image: ubuntu
      command: ["/bin/bash", "-c", "echo Container3"]
  restartPolicy: Never
```

---

# 🧠 Concept: Multi-Container Pod

👉 One Pod = Multiple Containers

✔️ All containers:

* Share same IP
* Share same network
* Can communicate via localhost

---

# 🚀 Step-by-Step Commands

---

## 🔹 1. Create YAML file

```bash
nano multiContainer.yml
```

---

## 🔹 2. Apply configuration

```bash
kubectl apply -f multiContainer.yml
```

👉 Output:

```bash
pod/multicontainerpod created ✅
```

---

## 🔹 3. Check Pod status

```bash
kubectl get pods
```

👉 Output:

```bash
multicontainerpod   Completed ✅
```

📌 From your output:


---

# 🔍 Why STATUS = Completed?

👉 Because containers run:

```bash
echo Container1
```

👉 and exit immediately
👉 So Pod completes execution

---

# 🔥 View Logs

## Default container logs

```bash
kubectl logs multicontainerpod
```

👉 Output:

```bash
Container1
```

---

## Specific container logs

```bash
kubectl logs multicontainerpod -c c02
kubectl logs multicontainerpod -c c03
```

---

# ⚠️ Important Concept

👉 If multiple containers exist:

* Default = first container (c01)
* Use `-c` to specify container

---

# ❗ Errors Faced & Fixes

---

## 🔴 Error 1: metadata.annotation (wrong)

```yaml
metadata:
  annotation: ❌
```

✅ Fix:

```yaml
metadata:
  annotations: ✔️
```

---

## 🔴 Error 2: Duplicate container name

```yaml
- name: c02
- name: c02 ❌
```

✅ Fix:

* All container names must be unique

---

## 🔴 Error 3: Exec not working

```bash
kubectl exec -it multicontainerpod -c c01 -- /bin/bash ❌
```

👉 Reason:

* Pod status = Completed (not running)

---

# 🧠 Important Learning

👉 `kubectl exec` works only when:

```bash
STATUS = Running ✔️
```

👉 Not when:

```bash
STATUS = Completed ❌
```

---

# 🔧 How to keep Pod running (IMPORTANT)

👉 Update command:

```yaml
command:
  - "/bin/bash"
  - "-c"
  - "while true; do echo Container1; sleep 5; done"
```

👉 Now:

```bash
STATUS = Running ✔️
```

👉 Then exec will work

---

# 💯 Key Learnings

* Pod can have multiple containers
* Containers must have unique names
* Logs are container-specific
* Completed pods cannot be exec-ed
* Use infinite loop to keep containers alive

---

# 🚀 Next Steps

* Sidecar container pattern
* Init containers
* Shared volumes
* Deployments

---

# 👨‍💻 Author

**Manish Kumar**
DevOps Learner 🚀

---

# ⭐ Support

If this helped:

* ⭐ Star repo
* Share with others
* Practice Kubernetes 🔥
