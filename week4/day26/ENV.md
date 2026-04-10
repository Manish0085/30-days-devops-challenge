# 🚀 Kubernetes Pod with Environment Variables (environment.yml) — Complete Guide

## 📌 Overview

This guide explains how to create a **Kubernetes Pod with Environment Variables**.

👉 Environment variables are used to:

* Pass configuration into containers
* Avoid hardcoding values
* Make applications flexible

---

# 📄 YAML File (environment.yml)

```yaml id="0xk3l1"
kind: Pod
apiVersion: v1
metadata:
  name: envpod
  annotations:
    description: "This is the example for creating env vars in the pod"
spec:
  containers:
    - name: c01
      image: ubuntu
      command:
        - "/bin/bash"
        - "-c"
        - "echo Example of Environment vars"
      env:
        - name: MYNAME
          value: DEVOPS
  restartPolicy: Never
```

---

# 🧠 What are Environment Variables?

👉 Environment variables are **key-value pairs** available inside a container.

Example:

```yaml id="v5w1kz"
env:
  - name: MYNAME
    value: DEVOPS
```

👉 Inside container:

```bash id="1m9w9s"
echo $MYNAME
```

---

# 🔍 YAML Explanation

| Field        | Meaning                 |
| ------------ | ----------------------- |
| name: envpod | Pod name                |
| annotations  | Extra metadata          |
| containers   | Container definition    |
| env          | Environment variables   |
| command      | What container executes |

---

# 🚀 Step-by-Step Commands

---

## 🔹 1. Create YAML file

```bash id="q4lq9x"
nano environment.yml
```

---

## 🔹 2. Apply configuration

```bash id="7n3v8m"
kubectl apply -f environment.yml
```

👉 Output:

```bash id="xq2b5s"
pod/envpod created ✅
```

---

## 🔹 3. Check Pod

```bash id="0o5d8u"
kubectl get pods
```

👉 Output:

```bash id="2g0j4z"
envpod   Completed ✅
```

📌 From your output:

* Pod runs command and exits → Completed

---

## 🔹 4. Check logs

```bash id="6v8b0c"
kubectl logs envpod
```

👉 Output:

```bash id="k4v3n1"
Example of Environment vars
```

---

# ⚠️ Important Concept

👉 Pod status = **Completed**

👉 Because:

```bash id="h0z8cv"
echo Example of Environment vars
```

👉 runs once and exits

---

# 🔧 How to use env variable (IMPORTANT)

👉 Update command:

```yaml id="m1o8we"
command:
  - "/bin/bash"
  - "-c"
  - "echo My name is $MYNAME && sleep 3600"
```

👉 Now:

```bash id="d7w1kq"
kubectl logs envpod
```

👉 Output:

```bash id="t2f9yo"
My name is DEVOPS
```

---

# ❗ Errors Faced & Fixes

---

## 🔴 Error: Invalid Pod Name

```bash id="8m3l4x"
envpod' ❌
```

👉 Problem:

* Extra `'` character

✅ Fix:

```yaml id="w6v7c1"
name: envpod ✔️
```

---

## 🔴 Pod Completed immediately

👉 Reason:

* Command exits instantly

✅ Fix:

```bash id="l7v9j2"
sleep 3600
```

---

# 💯 Key Learnings

* Environment variables help dynamic configuration
* YAML structure is important
* Commands decide pod lifecycle
* Completed pods cannot be exec-ed

---

# 🚀 Next Steps

* Use ConfigMaps
* Use Secrets
* Inject env from ConfigMap
* Deploy real applications

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
