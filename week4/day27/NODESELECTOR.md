# 🚀 Kubernetes Node Selector (nodeSelector.yml) — Complete Guide

## 📌 Overview

This guide explains how to use **Node Selector in Kubernetes** to schedule Pods on specific nodes.

👉 Node Selector is used to:

* Control **where Pods run**
* Assign workloads to specific machines
* Use node labels for scheduling

---

# 📄 YAML File (nodeSelector.yml)

```yaml
kind: Pod
apiVersion: v1
metadata:
  name: nodeselectorpod
  annotations:
    description: "This is the example of assigning the label to node and then running the pod on that node"
  labels:
    env: development
    createdBy: developer
spec:
  containers:
    - name: c01
      image: ubuntu
      command:
        - "/bin/bash"
        - "-c"
        - "while true; do echo Tagging the node with selector; sleep 5; done"
  nodeSelector:
    hardware: t2-medium
```

---

# 🧠 What is Node Selector?

👉 Node Selector allows you to **schedule a Pod on a specific node** using labels.

👉 Example:

```yaml
nodeSelector:
  hardware: t2-medium
```

👉 This means:
➡️ Pod will run only on nodes having label `hardware=t2-medium`

---

# 🚀 Step-by-Step Execution

---

## 🔹 1. Check available nodes

```bash
kubectl get nodes
```

---

## 🔹 2. Add label to node

```bash
kubectl label node minikube hardware=t2-medium
```

👉 Verify:

```bash
kubectl get nodes --show-labels
```

---

## 🔹 3. Create YAML file

```bash
nano nodeSelector.yml
```

---

## 🔹 4. Apply configuration

```bash
kubectl apply -f nodeSelector.yml
```

---

## 🔹 5. Check Pod

```bash
kubectl get pods -o wide
```

👉 Output:

* Pod should be scheduled on the labeled node ✔️

---

# 🔍 Verify Scheduling

```bash
kubectl describe pod nodeselectorpod
```

👉 Look for:

```
Node: minikube
Node-Selectors: hardware=t2-medium
```

---

# ❗ Errors Faced & Fixes

---

## 🔴 Error: Pod Pending

👉 Reason:

```
0/1 nodes are available: node didn't match selector
```

✅ Fix:

```bash
kubectl label node minikube hardware=t2-medium
```

---

## 🔴 Error: Container Crash (BackOff)

👉 Cause:

* Wrong command syntax
* Missing loop or incomplete command

Example error:

```
/bin/bash: syntax error: unexpected end of file
```

✅ Fix:

```yaml
command:
  - "/bin/bash"
  - "-c"
  - "while true; do echo Tagging the node with selector; sleep 5; done"
```

---

## 🔴 Error: YAML structure

👉 Wrong:

```
containers:
  name: c01 ❌
```

✅ Correct:

```
containers:
  - name: c01 ✔️
```

---

# 💯 Key Learnings

* Node Selector controls Pod placement
* Nodes must be labeled before scheduling
* Pods remain **Pending** if no matching node found
* Proper command is required to keep container running
* Useful for workload isolation

---

# 🚀 Real Use Cases

* Assign DB Pods to high-memory nodes
* Run GPU workloads on GPU nodes
* Separate dev, staging, production workloads

---

# 📌 Commands Summary

```bash
# Label node
kubectl label node minikube hardware=t2-medium

# Apply pod
kubectl apply -f nodeSelector.yml

# Check pods
kubectl get pods -o wide

# Describe pod
kubectl describe pod nodeselectorpod

# Delete pods using label
kubectl delete pod -l env=development
```

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
