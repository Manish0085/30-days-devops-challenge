# 🚀 Kubernetes NodePort Service (External Access)

This project demonstrates how to expose an application running inside Kubernetes to the outside world using a **NodePort Service**.

---

## 📌 Objective

* Understand how to access applications from outside the cluster
* Learn how NodePort exposes services on a node’s IP
* Enable external communication to Pods

---

## 🧠 Problem

By default, Kubernetes Services (ClusterIP) are:

* Internal only
* Not accessible from outside the cluster

```text
External User → ClusterIP ❌ Not Accessible
```

---

## ✅ Solution: NodePort Service

A **NodePort Service** exposes the application on a static port on each node.

```text
External User → NodeIP:NodePort → Service → Pods ✅
```

---

## 🔹 What is NodePort?

* Exposes Service on a port (range: 30000–32767)
* Accessible using:

  * Node IP
  * NodePort
* Routes traffic to backend Pods

---

## ⚙️ Example Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mydeployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
        - name: c01
          image: nginx
          ports:
            - containerPort: 80
```

---

## ⚙️ Example NodePort Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: demoservice
spec:
  selector:
    app: myapp
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30007   # optional (Kubernetes can auto-assign)
  type: NodePort
```

---

## 🔄 How It Works

1. Deployment creates Pods
2. Service selects Pods using labels
3. NodePort exposes the Service on each node
4. External traffic is routed to Pods

```text
Browser → NodeIP:30007 → Service → Pod1 / Pod2
```

---

## 🔍 How to Get NodePort

```bash
kubectl get svc
```

Example output:

```text
NAME          TYPE       CLUSTER-IP       PORT(S)
demoservice   NodePort   10.x.x.x         80:30007/TCP
```

---

## 🌐 Access Application

### 🔹 If using Minikube

```bash
minikube ip
```

Then:

```bash
curl <minikube-ip>:30007
```

---

### 🔹 If using EC2 / VM

```bash
curl <node-public-ip>:30007
```

---

## ⚠️ Important Notes

* Ensure security group allows NodePort range (30000–32767)
* NodePort exposes service on all nodes
* Not recommended for production (use LoadBalancer/Ingress)

---

## 💡 Key Concepts

| Feature  | ClusterIP         | NodePort        |
| -------- | ----------------- | --------------- |
| Access   | Internal          | External        |
| Port     | Internal only     | 30000–32767     |
| Use Case | Pod communication | External access |

---

## 🧠 Key Learning

* NodePort exposes applications outside the cluster
* It acts as a bridge between external users and internal Pods
* It still uses Service for load balancing

---

## 🎯 Conclusion

NodePort allows external access to Kubernetes applications by exposing them on a node’s IP and port, making it easy to test and access services from outside the cluster.

---

## 🚀 Next Steps

* Learn LoadBalancer Service
* Explore Ingress Controller
* Understand production-grade exposure

---

# 🔥 Final Insight

```text
NodePort = External Access (Node IP + Port) → Service → Pods
```
