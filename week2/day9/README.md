# Day 9 — Docker Hub Push + Image Versioning

## What I Did Today
- Logged into Docker Hub from terminal using Access Token
- Tagged the News App Docker image with proper naming convention
- Pushed image to Docker Hub — available globally
- Added `.dockerignore` to exclude unnecessary files
- Versioned the image with both `latest` and `v1.0` tags
- Inspected image layers using `docker history` and `docker inspect`

---

## Commands Used

### Docker Hub Login
```bash
docker login -u your_dockerhub_username
# Use Access Token as password — not your account password
```

### Image Tagging
```bash
docker tag news-app manish0085/news-app:latest
docker tag news-app manish0085/news-app:v1.0
```

### Push to Docker Hub
```bash
docker push manish0085/news-app:latest
docker push manish0085/news-app:v1.0
```

### Pull from Docker Hub (any machine)
```bash
docker pull manish0085/news-app:latest
docker pull manish0085/news-app:v1.0
```

### Inspect Image
```bash
docker inspect manish0085/news-app:latest
docker history manish0085/news-app:latest
```

---

## .dockerignore
```
target/
*.log
.git
.env
*.md
```

---

## Concepts Learned

| Concept | Description |
|--------|-------------|
| `docker tag` | Image ko proper name dena — username/imagename:tag format |
| `docker push` | Docker Hub pe image upload karna |
| `docker pull` | Kisi bhi machine se image download karna |
| `.dockerignore` | Unnecessary files exclude karo — image size kam hoti hai |
| `docker history` | Har layer dikhti hai — size aur command |
| `docker inspect` | Image ki complete metadata — env vars, ports, layers |
| Image Versioning | `latest` + `v1.0` — rollback ke liye zaroori |

---

## Key Learnings
- Docker Hub password authentication band hai — **Access Token** use karo
- Image naming convention — `username/imagename:tag`
- `.dockerignore` = `.gitignore` for Docker — always banao
- Versioning zaroori hai — `latest` akela kaafi nahi production mein

---

## Docker Hub
Image available at: `docker pull manish0085/news-app:latest`
