# Day 17 — GitHub Webhook + Automated Jenkins Pipeline

## What I Did Today
- Connected GitHub repository to Jenkins via Webhook
- Every `git push` to main branch automatically triggers Jenkins pipeline
- Jenkinsfile with 5 stages — Build, Test, Docker Build, Docker Push, Deploy
- Weather App (Spring Boot) fully automated CI/CD pipeline

---

## How It Works
```
git push origin main
        ↓
GitHub sends webhook → Jenkins URL
        ↓
Jenkins receives trigger
        ↓
Pipeline starts automatically
        ↓
Build → Test → Docker Build → Docker Push → Deploy
        ↓
Weather App live on EC2!
```

---

## Jenkinsfile
```groovy
pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "manish0085/weather-app"
        DOCKER_TAG = "${BUILD_NUMBER}"
    }

    stages {
        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .'
                sh 'docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest'
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh 'docker push ${DOCKER_IMAGE}:${DOCKER_TAG}'
                    sh 'docker push ${DOCKER_IMAGE}:latest'
                }
            }
        }

        stage('Deploy') {
            steps {
                sh 'docker stop weather-app || true'
                sh 'docker rm weather-app || true'
                sh 'docker run -d --name weather-app -p 8080:8080 -e WEATHER_APIKEY=${WEATHER_APIKEY} ${DOCKER_IMAGE}:latest'
            }
        }
    }

    post {
        success {
            echo 'Pipeline successful — Weather App deployed!'
        }
        failure {
            echo 'Pipeline failed — check logs!'
        }
    }
}
```

---

## GitHub Webhook Setup

### Step 1 — GitHub Repository Settings
```
GitHub Repo → Settings → Webhooks → Add Webhook
Payload URL  → http://JENKINS_PUBLIC_IP:8080/github-webhook/
Content Type → application/json
Events       → Just the push event
Active       → ✓
```

### Step 2 — Jenkins Job Configuration
```
Jenkins → Job → Configure
Build Triggers → ✓ GitHub hook trigger for GITScm polling
```

### Step 3 — Verify
```bash
# Code push karo
git add .
git commit -m "test webhook trigger"
git push origin main

# Jenkins pe jaao — pipeline automatically start hogi!
```

---

## Commands Used

```bash
# Manual pipeline trigger
# Jenkins Dashboard → Job → Build Now

# Docker image check
docker images | grep weather-app

# Running container check
docker ps | grep weather-app

# App test
curl http://localhost:8080/weather/Delhi
```

---

## Concepts Learned

| Concept | Description |
|--------|-------------|
| GitHub Webhook | Code push hone pe Jenkins ko automatically notify karta hai |
| Payload URL | `http://JENKINS_URL:8080/github-webhook/` — Jenkins ka endpoint |
| GITScm Polling | Jenkins job mein webhook trigger enable karna |
| BUILD_NUMBER | Jenkins ka built-in variable — har build ka unique number |
| withCredentials | Docker Hub credentials securely use karna |
| post block | Pipeline success/failure pe action lena |

---

## Key Learnings
- Jenkins publicly accessible hona chahiye — GitHub webhook reach kar sake
- `|| true` — command fail ho toh pipeline mat roko (container exist na kare toh bhi)
- `BUILD_NUMBER` se image versioning automatic hoti hai
- Credentials Jenkins mein store karo — Jenkinsfile mein hardcode mat karo
- Webhook = Push event → automatic trigger — manual Jenkins click band!

---

## CI/CD Flow
```
Developer → git push
               ↓
          GitHub Webhook
               ↓
          Jenkins Pipeline
               ↓
    ┌──────────────────────┐
    │ Stage 1: Build       │ mvn clean package
    │ Stage 2: Test        │ mvn test  
    │ Stage 3: Docker Build│ docker build
    │ Stage 4: Docker Push │ docker push
    │ Stage 5: Deploy      │ docker run
    └──────────────────────┘
               ↓
      Weather App Live! 🚀
```
