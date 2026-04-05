# Day 18 — Jenkinsfile: Pipeline as Code 🚀

## What I Did

Moved the Jenkins pipeline from the GUI into a `Jenkinsfile` — stored directly inside the GitHub repository. This is called **Pipeline as Code**.

---

## Why Jenkinsfile?

| GUI Pipeline | Jenkinsfile |
|-------------|-------------|
| Lives in Jenkins only | Lives in GitHub repo |
| Not version controlled | Version controlled |
| Can't be reviewed | Team can review it |
| Lost if Jenkins crashes | Always recoverable |
| Hard to replicate | Clone repo = pipeline ready |

---

## Project — Resume Analyzer

An AI-powered Resume Analyzer built with Spring AI and OpenRouter API.

```
Resume-Analyzer/
├── backend/          ← Spring Boot + Spring AI
│   └── .env          ← OpenRouter API Key
├── frontend/         ← React
│   └── .env          ← Frontend env vars
├── docker-compose.yml
└── Jenkinsfile       ← Pipeline as Code
```

---

## Jenkinsfile Structure

```groovy
pipeline {
    agent any          // Run on any Jenkins machine

    options {
        timestamps()   // Add timestamps to every log line
    }

    environment {
        PROJECT_NAME = "Resume Analyzer"  // Global env variable
    }

    stages { ... }    // All pipeline stages

    post { ... }      // Run after pipeline — success/failure actions
}
```

---

## Key Concepts Learned

### `options { timestamps() }`
Adds timestamp to every single log line. Makes debugging much easier — you know exactly when each step ran.

### `environment {}`
Define global variables available across all stages.
```groovy
environment {
    PROJECT_NAME = "Resume Analyzer"
    DOCKER_IMAGE = "manishk57107/resume-analyzer"
}
```

### `withCredentials`
Securely inject secrets into pipeline — API keys, .env files, passwords.
```groovy
withCredentials([
    file(credentialsId: 'backend-env-file', variable: 'BACKEND_ENV')
]) {
    sh 'cp "$BACKEND_ENV" backend/.env'
}
```
The secret never appears in logs. Jenkins masks it automatically.

### `post {}` block
Runs after pipeline completes — regardless of success or failure.
```groovy
post {
    success { /* send success email */ }
    failure { /* send failure email */ }
    always  { /* always runs */ }
}
```

---

## Stages Breakdown

```
Stage 1: Clean Workspace     → deleteDir() — fresh start
Stage 2: Clone Repository    → git pull from GitHub
Stage 3: Load ENV Files      → copy .env files securely
Stage 4: Verify Docker       → confirm docker is available
Stage 5: Stop Old Containers → docker-compose down
Stage 6: Build Docker Images → docker-compose build
Stage 7: Start Containers    → docker-compose up -d
Stage 8: Verify Containers   → docker ps
Stage 9: Health Check        → curl localhost
```

---

## How to Configure in Jenkins

1. Jenkins → New Item → Pipeline
2. Pipeline → Definition → **Pipeline script from SCM**
3. SCM → **Git**
4. Repository URL → `https://github.com/Manish0085/Resume-Analyzer.git`
5. Branch → `main`
6. Script Path → `Jenkinsfile`
7. Save

Now Jenkins reads the pipeline directly from the repo!

---

## Week 3 Progress

```
✓ Day 15 — Jenkins install + setup
✓ Day 16 — First Jenkins Pipeline
✓ Day 17 — GitHub Webhook
✓ Day 18 — Jenkinsfile — Pipeline as Code
→ Day 19 — Docker build + push inside pipeline
→ Day 20 — Auto deploy to EC2
→ Day 21 — Complete CI/CD pipeline end to end
```

---

> Built as part of 30 Days DevOps Challenge
> GitHub: https://github.com/Manish0085/30-days-devops-challenge
