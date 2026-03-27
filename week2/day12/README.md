# Day 12 — Docker Volumes + Networking + 3-Tier Deployment

## What I Did Today
- Deployed a full 3-tier application using Docker Compose
- Implemented Docker Volume for PostgreSQL data persistence
- Created custom bridge network for container communication
- Fixed port mapping issues for Nginx frontend
- Deployed AI Expense Tracker (React + Spring Boot + PostgreSQL) on EC2

---

## Architecture
```
User Request
     ↓
Port 5173 → Frontend Container (React + Nginx)
     ↓
Port 8081 → Backend Container (Spring Boot)
     ↓
Port 5432 → PostgreSQL Container (internal only)
     ↓
postgres-data Volume → EC2 Host (data persists!)
```

---

## Project Structure
```
Smart-Ai-Expanse-Tarcker/
├── docker-compose.yml
├── .env                      ← root level nahi tha — fix kiya
├── ai-expanse-tacker/
│   ├── Dockerfile
│   └── .env
└── frontend/
    ├── Dockerfile
    └── .env
```


---

## Commands Used

### Start all containers
```bash
docker compose up -d
```

### Stop all containers
```bash
docker compose down
```

### Check container status
```bash
docker compose ps
```

### Check logs
```bash
docker compose logs expanse-backend
docker compose logs expanse-frontend
docker compose logs postgres
```

### Volume list karo
```bash
docker volume ls
```

### Volume inspect karo
```bash
docker volume inspect smart-ai-expanse-tarcker_postgres-data
```

---

## Concepts Learned

| Concept | Description |
|--------|-------------|
| Docker Volume | Container delete hone pe bhi data EC2 pe safe rehta hai |
| Named Volume | `postgres-data:/var/lib/postgresql/data` — Docker manage karta hai |
| Custom Bridge Network | Containers naam se ek dusre ko access karte hain |
| Docker DNS | `postgres:5432` — naam se IP resolve hoti hai automatically |
| depends_on | Container start order define karna |
| Port Mapping | `5173:80` — bahar 5173, Nginx andar 80 pe serve karta hai |
| env_file | Har service ka apna .env — clean aur secure |

---

## Key Learnings
- **Volume vs No Volume** — Container restart pe data gone, volume se data safe
- **postgres:latest vs postgres:16** — latest ne v18 release kiya — format change se error aaya
- **5173:5173 vs 5173:80** — Nginx andar 80 pe serve karta hai, bahar 5173 map karo
- **Custom Bridge Network** — Default bridge mein naam se access nahi hota, custom mein hota hai
- **env_file path** — docker-compose.yml ke relative path hona chahiye

---

## Errors Fixed
| Error | Cause | Fix |
|-------|-------|-----|
| postgres exited code 1 | postgres:latest = v18, format change | postgres:16 use kiya |
| Frontend not accessible | 5173:5173 — Nginx 80 pe tha | 5173:80 kiya |
| env file not found | .env root mein nahi tha | path fix kiya — `./ai-expanse-tacker/.env` |
OA| Maven OOM on t2.micro | 1GB RAM — Maven build fail | Pre-built jar use kiya |
