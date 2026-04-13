# 🚀 Kubernetes Pod to Pod Communication

This project demonstrates how two Pods communicate with each other inside a Kubernetes cluster using their internal Pod IPs.

---

## 📌 Objective

* Create two Pods:

  * `testpod1` → runs **nginx**
  * `testpod2` → runs **Apache (httpd)**
* Test communication between them using **Pod IPs**

---

## 📁 YAML Configuration

### 🔹 Pod 1 (Nginx)

```yaml
kind: Pod
apiVersion: v1
metadata:
  name: testpod1
  annotations:
    description: This is the pod testpod1 inside the node1
spec:
  containers:
    - name: c01
      image: nginx
      ports:
        - containerPort: 80
```

---

### 🔹 Pod 2 (Apache)

```yaml
kind: Pod
apiVersion: v1
metadata:
  name: testpod2
  annotations:
    description: This is the another example of container communication
spec:
  containers:
    - name: c02
      image: httpd
      ports:
        - containerPort: 80
```

---

## ⚙️ Steps to Run

### 1️⃣ Apply both Pods

```bash
kubectl apply -f pod3.yml
kubectl apply -f pod4.yml
```

---

### 2️⃣ Check Pods

```bash
kubectl get pods -o wide
```

Example Output:

```
testpod1   Running   10.244.0.45
testpod2   Running   10.244.0.46
```

---

### 3️⃣ Enter inside a Pod

```bash
kubectl exec -it testpod2 -- /bin/bash
```

---

### 4️⃣ Install curl (if not available)

```bash
apt update && apt install curl -y
```

---

### 5️⃣ Test Communication

👉 From testpod2 → testpod1

```bash
curl 10.244.0.45:80
```

✅ Output:

```
Welcome to nginx!
```

---

👉 From testpod1 → testpod2

```bash
kubectl exec -it testpod1 -- /bin/bash
curl 10.244.0.46:80
```

✅ Output:

```
It works! Apache httpd
```

---

## 💡 Important Concepts

### 🔹 Pod IP

* Each Pod gets a unique IP inside the cluster
* Example: `10.244.x.x`
* These IPs are **internal only**

---

### 🔹 Communication Rules

| Source         | Destination | Works? |
| -------------- | ----------- | ------ |
| Pod → Pod      | ✅           |        |
| Host → Pod     | ❌           |        |
| External → Pod | ❌           |        |

---

### 🔹 Why curl failed from host?

```bash
curl 10.244.0.45:80
```

❌ Reason:

* Pod IPs are **not accessible from outside cluster**

---

## ⚠️ Best Practice

❌ Do NOT use Pod IP in production
✅ Always use **Service**

---

## 🔥 Key Learnings

* Pods can communicate using internal networking
* Each Pod has its own isolated network
* Kubernetes networking is **flat (no NAT between pods)**
* Services are required for stable communication

---

## 🎯 Conclusion

This example proves that:

👉 Kubernetes allows seamless Pod-to-Pod communication
👉 Internal networking works without any manual configuration
👉 For real-world apps → always use Services

---

## 🚀 Next Step

* Learn about:

  * ClusterIP
  * NodePort
  * LoadBalancer
