# Day 16 — First Jenkins Pipeline 🚀

## What I Built

Created my first Jenkins Pipeline with 3 stages — understanding the difference between Freestyle Projects and Pipeline Projects, and writing a Groovy-based declarative pipeline from scratch.

---

## The Mistake That Taught Me the Most

Pasted a Groovy pipeline script into a **Freestyle Project**.

Jenkins said:
```
pipeline: not found
Build step 'Execute shell' marked build as failure
```

**Why?** Freestyle Projects only accept shell commands. Groovy pipeline syntax doesn't work there. The right place is a **Pipeline Project**.

---

## Freestyle vs Pipeline

| Feature | Freestyle | Pipeline |
|---------|-----------|----------|
| Configuration | GUI based | Code based |
| Definition | Clicks and forms | Groovy script |
| Version Control | Not possible | Jenkinsfile in repo |
| Flexibility | Limited | Full control |
| Production use | Rare | Standard |

---

## My First Pipeline

```groovy
pipeline {
    agent any
    stages {
        stage('Hello') {
            steps {
                echo "Hello Guys..."
            }
        }
        stage('Work') {
            steps {
                echo "This is second jenkins pipeline"
                sh "whoami"
                sh "date"
            }
        }
        stage('Bye') {
            steps {
                echo "Bye Guys..."
            }
        }
    }
}
```

---

## Pipeline Building Blocks

### `pipeline {}`
Wraps the entire script. Jenkins reads everything inside this block.

### `agent any`
Tells Jenkins — run this pipeline on any available machine.

```groovy
agent any              // any available machine
agent { label 'linux' } // specific machine
agent none             // define per stage
```

### `stages {}`
Container for all your stages. All stages go inside this block.

### `stage('name') {}`
A logical step in your pipeline. Give it a meaningful name — this is what shows up on the Jenkins dashboard.

```groovy
stage('Build') {}
stage('Test') {}
stage('Docker Build') {}
stage('Deploy to EC2') {}
```

### `steps {}`
Actual commands that run inside a stage.

```groovy
steps {
    echo 'Hello'           // print to console
    sh 'mvn clean package' // run shell command (Linux)
    sh 'docker build .'    // any shell command
}
```

---

## How to Create a Pipeline Job

1. Jenkins Dashboard → **New Item**
2. Enter a name
3. Select **Pipeline** — NOT Freestyle
4. Click OK
5. Scroll to **Pipeline** section
6. Paste your Groovy script in the **Script** box
7. **Save** → **Build Now**

---

## Reading the Dashboard

Jenkins shows each stage as a separate block:

```
[Hello] ✓  →  [Work] ✓  →  [Bye] ✓
```

- 🟢 Green — Stage passed
- 🔴 Red — Stage failed
- 🔵 Blue — Stage running

**Important:** If one stage fails — pipeline stops immediately. It does not move to the next stage.

This is exactly how production pipelines work:
- Build fails → nothing gets deployed
- Tests fail → nothing reaches production

**Fail fast. Fail loud. Fix it. Move on.**

---

## Key Concepts Learned

| Concept | Meaning |
|---------|---------|
| `pipeline` | Wraps entire script |
| `agent any` | Run on any Jenkins machine |
| `stages` | Container for all stages |
| `stage` | One logical step |
| `steps` | Actual commands |
| `echo` | Print to console |
| `sh` | Run Linux shell command |

---

## What's Next

Right now the pipeline just runs echo and basic commands. Coming days this same pipeline will:

- Pull code from GitHub automatically
- Build with Maven
- Build a Docker image
- Push to Docker Hub
- Deploy to EC2

---

## Week 3 Progress

```
✓ Day 15 — Jenkins install + setup on EC2
✓ Day 16 — First Jenkins Pipeline — 3 stages running successfully
→ Day 17 — GitHub webhook — auto trigger on push
→ Day 18 — Jenkinsfile — Pipeline as Code
→ Day 19 — Docker build + push inside pipeline
→ Day 20 — Auto deploy to EC2
→ Day 21 — Complete CI/CD pipeline end to end
```

---

> Built as part of 30 Days DevOps Challenge
> GitHub: https://github.com/Manish0085/30-days-devops-challenge
