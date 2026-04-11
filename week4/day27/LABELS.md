# 🚀 Kubernetes Labels & Selectors (labels.yml) — Complete Guide

## 📌 Overview

This guide explains how to use **Labels and Selectors in Kubernetes**.

👉 Labels are used to:

* Organize resources
* Filter Pods
* Select groups of resources

---

# 📄 YAML File (labels.yml)

```yaml
kind: Pod
apiVersion: v1
metadata:
  name: labelpod
  annotations:
    description: "This is the example of giving label to the pod"
  labels:
    class: pod
    env: development
    example: label
spec:
  containers:
    - name: c01
      image: ubuntu
      command:
        - "/bin/bash"
        - "-c"
        - "while true; do echo this is the example of giving label to the pod; sleep 5; done"
  restartPolicy: Never
```

---

# 🧠 What are Labels?

👉 Labels are **key-value pairs** attached to Kubernetes objects.

Example:

```yaml
labels:
  class: pod
  env: development
```

👉 Used for:

* Filtering Pods
* Grouping resources
* Service selection

---

# 🚀 Step-by-Step Execution

---

## 🔹 1. Create YAML file

```bash
nano labels.yml
```

---

## 🔹 2. Apply configuration

```bash
kubectl apply -f labels.yml
```

👉 Output:

```
pod/labelpod created ✅
```

---

## 🔹 3. Check Pods

```bash
kubectl get pods
```

---

## 🔹 4. Show Labels

```bash
kubectl get pods --show-labels
```

👉 Output:

```
labelpod   class=pod,env=development,example=label
```

---

# 🔍 Label Selectors (IMPORTANT)

---

## 🔹 1. Match specific label

```bash
kubectl get pods -l class=pod
```

---

## 🔹 2. Match environment

```bash
kubectl get pods -l env=development
```

---

## 🔹 3. Not equal selector

```bash
kubectl get pods -l class!=pod
```

---

## 🔹 4. Multiple values (IN operator)

```bash
kubectl get pods -l 'class in(pod, node)'
```

👉 ⚠️ Quotes required (`' '`)

---

## 🔹 5. NOT IN operator

```bash
kubectl get pods -l 'env notin(testing, production)'
```

---

# 🏷️ Add Label Dynamically

```bash
kubectl label pod labelpod createdBy=developer
```

👉 Verify:

```bash
kubectl get pods --show-labels
```

---

# 🗑️ Delete using Labels

```bash
kubectl delete pod -l createdBy=developer
```

👉 Deletes all pods matching label

---

# ❗ Errors Faced & Fixes

---

## 🔴 Error: --show-label

```bash
kubectl get pods --show-label ❌
```

✅ Correct:

```bash
kubectl get pods --show-labels ✔️
```

---

## 🔴 Error: selector syntax

```bash
kubectl get pods -l env in(development, testing) ❌
```

✅ Fix:

```bash
kubectl get pods -l 'env in(development, testing)' ✔️
```

---

## 🔴 Error: mixing commands

```bash
kubectl get pods -l kubectl delete pod ... ❌
```

👉 Commands must be separate

---

# 💯 Key Learnings

* Labels help organize Kubernetes resources
* Selectors allow filtering and grouping
* Quotes are required in complex selectors
* Labels can be added dynamically
* Labels are heavily used in Services & Deployments

---

# 🚀 Next Steps

* Use Labels with Services
* Deploy apps using Deployments
* Learn Label Selectors in depth
* Setup Load Balancing

---

# 👨‍💻 Author

**Manish Kumar**
DevOps Learner 🚀

---

# ⭐ Support

If this helped:

* ⭐ Star this repo
* Share with others
* Keep learning Kubernetes 🔥
