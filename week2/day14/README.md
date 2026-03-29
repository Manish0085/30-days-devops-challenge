# Day 14 — Week 2 End Project: Full Stack Ecommerce Deployment 🚀

## What I Built

Deployed a complete full-stack Ecommerce application using Docker Compose — PostgreSQL database, Spring Boot backend, and React frontend — all running as containers on AWS EC2 with a single shell script.

---

## Project Stack

| Service | Technology | Port |
|---------|-----------|------|
| Database | PostgreSQL 16 | 5432 |
| Backend | Spring Boot (Java 21) | 8080 |
| Frontend | React + Nginx | 5173 |

---

## Files

```
day14/
├── docker-compose.yml        ← Multi-container setup
├── ecommerce_deploy.sh       ← Automated deployment script
└── README.md
```

---

## Scripts

### `ecommerce_deploy.sh`

Automated deployment pipeline:

```
check_compose()     → docker-compose.yml exist karo check
stop_existing()     → purane containers stop karo
build_and_deploy()  → docker compose up --build -d
check_services()    → sab services running hain verify karo
```

---

## How to Run

```bash
# Clone karo
git clone https://github.com/Manish0085/30-days-devops-challenge.git
cd week2/day14

# Deploy karo
bash ecommerce_deploy.sh

# Status check karo
docker compose ps

# Logs dekho
docker compose logs -f
```

---

## Docker Compose Structure

```yaml
services:
  postgres:     # Database
  backend:      # Spring Boot API
  frontend:     # React App
```

---

## Key Concepts Learned

- `docker compose up --build` — build + start in one command
- `depends_on` — service startup order control
- `volumes` — PostgreSQL data persist karna
- `networks` — containers ek dusre se communicate karte hain
- `docker compose logs` — container logs script se padhna
- `docker compose ps` — service status check karna
- Multi-stage Dockerfile — Java 21 JDK build, JRE runtime

---

## Errors & Fixes

| Error | Fix |
|-------|-----|
| `release version 21 not supported` | Java 17 → Java 21 image use kiya |
| `detached entity passed to persist: Role` | `adminRoles` fresh DB se load kiya |
| `version attribute obsolete` | docker-compose.yml se version line hatai |
| Backend container crash | JPA CascadeType issue in WebSecurityConfig |

---

## Week 2 Complete! 🎉

```
✓ Day 8  — Dockerfile + Spring Boot containerize
✓ Day 9  — Docker Hub push + pull
✓ Day 10 — Docker Compose + Nginx reverse proxy
✓ Day 11 — Multi-stage Dockerfile
✓ Day 12 — Docker Volumes + Networking
✓ Day 13 — Docker + Shell Script automation
✓ Day 14 — Full Stack Ecommerce deployment
```

---

> Next: Week 3 — Jenkins CI/CD Pipeline 🔥
