# 🚀 Kubernetes Pod with Annotations (annotation.yml) — Complete Guide

## 📌 Overview

This guide explains how to create a **Kubernetes Pod with Annotations** using a YAML file.

👉 Includes:

* YAML explanation
* Step-by-step commands
* Real errors & fixes
* Verification

---

# 📄 YAML File (annotation.yml)

```yaml
kind: Pod
apiVersion: v1
metadata:
  name: testpod
  annotations:
    description: "This is an example of annotation"
spec:
  containers:
    - name: co1
      image: ubuntu
      command:
        - "/bin/bash"
        - "-c"
        - "while true; do echo Annotation example; sleep 5; done"
  restartPolicy: Never
```

---

# 🧠 What are Annotations?

👉 Annotations are **key-value pairs** used to store extra information about Kubernetes objects.

✔️ Used for:

* Metadata
* Documentation
* Tool integrations

👉 Example:

```yaml
annotations:
  description: "This is an example of annotation"
```

---

# 🔍 YAML Explanation

### 🔹 metadata.annotations

👉 Adds custom information to the Pod

---

### 🔹 Container Command

```bash
while true; do echo Annotation example; sleep 5; done
```

👉 Infinite loop:

* Prints message every 5 seconds
* Keeps container running

---

# 🚀 Step-by-Step Execution

---

## 🔹 1. Create file

```bash
nano annotation.yml
```

👉 Paste YAML

---

## 🔹 2. Apply configuration

```bash
kubectl apply -f annotation.yml
```

👉 Output:

```
pod/testpod created ✅
```

---

## 🔹 3. Verify Pod

```bash
kubectl get pods
```

👉 Output:

```
testpod   Running ✅
```

---

## 🔹 4. Detailed description

```bash
kubectl describe pod testpod
```

👉 Important section:

```
Annotations:
  description: This is an example of annotation
```

📌 Verified from your output:


---

## 🔹 5. Check logs

```bash
kubectl logs testpod
```

👉 Output:

```
Annotation example
Annotation example
```

---

## 🔹 6. Delete Pod

```bash
kubectl delete pod testpod
```

---

# ❗ Errors Faced & Fixes

---

## 🔴 Error 1: mapping values are not allowed

👉 Cause:

* Incorrect YAML formatting

✅ Fix:

* Use proper indentation (2 spaces)

---

## 🔴 Error 2: unexpected end of stream

👉 Cause:

* File incomplete / missing bracket

✅ Fix:

* Ensure YAML properly closed

---

## 🔴 Error 3: unknown field "spec.container"

👉 Cause:

```yaml
spec:
  container: ❌
```

✅ Fix:

```yaml
spec:
  containers: ✔️
```

---

## 🔴 Error 4: Resource type mistake

```bash
kubectl describe testpod ❌
```

✅ Correct:

```bash
kubectl describe pod testpod ✔️
```

---

# 💯 Key Learnings

* Annotations store extra metadata
* YAML formatting is critical
* Commands must be precise
* `kubectl describe` helps verify annotations

---

# 🚀 Next Steps

* Use Labels + Selectors
* Create Deployments
* Add Services
* Learn Ingress

---

# 👨‍💻 Author

**Manish Kumar**
DevOps Learner 🚀

---

# ⭐ Support

If this helped:

* ⭐ Star this repo
* Share with others
* Practice more Kubernetes 🔥
