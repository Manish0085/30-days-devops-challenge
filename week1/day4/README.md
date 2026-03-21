# Day 4 — Spring Boot App Deployment Automation

## Goal
Write a script that deploys a real Spring Boot Weather API on EC2 — kill old process, deploy new jar, pass environment variables, verify app is running.

---

## Script Built
**`deploy_app.sh`**

---

## What the Script Does

```
Check jar file exists
    ↓
Kill existing process on port 8080
    ↓
Export environment variables
    ↓
Run jar in background
    ↓
Wait 20 seconds
    ↓
Health check via curl
    ↓
Print result
```

---

## App Deployed
**Spring Boot Weather API** — fetches weather data for any city using WeatherStack API.

- Port: `8080`
- Endpoint: `/weather/{city}`
- Environment variable required: `WEATHER_APIKEY`

---

## Commands Learned

### Process Management
```bash
# Find process running on a port
lsof -t -i:8080          # Returns PID of process on port 8080

# Kill process
kill -9 $PID             # Force kill process

# Check if variable is not empty
if [[ -n "$PID" ]]; then
    kill -9 "$PID"
fi
```

### Running Java App in Background
```bash
# Run jar in background, save logs to file
java -jar app.jar > app.log 2>&1 &

# $! = PID of last background process
echo "App running with PID: $!"
```

### Passing Environment Variables
```bash
# Export makes variable available to child processes
export WEATHER_APIKEY="your-api-key"
export PORT=8080
java -jar app.jar > app.log 2>&1 &
```

### Health Check with Curl
```bash
# Silent curl — only returns HTTP status code
curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/weather/Delhi

# -s = silent mode
# -o /dev/null = throw away response body
# -w "%{http_code}" = print only status code (200, 404, 500)
```

### Build Spring Boot Jar
```bash
mvn clean package -DskipTests    # Build jar, skip tests
# Output: target/appname-0.0.1-SNAPSHOT.jar
```

### SCP Jar to EC2
```bash
scp -i key.pem target/app.jar ubuntu@EC2_IP:/home/ubuntu/
```

---

## Key Concepts Learned

| Concept | What it means |
|---------|--------------|
| `lsof -t -i:PORT` | Find PID of process on specific port |
| `kill -9` | Force kill a process |
| `$!` | PID of last background process |
| `export` | Pass variable to child processes |
| `&` | Run command in background |
| `> file 2>&1` | Redirect all output (stdout + stderr) to file |
| `-w "%{http_code}"` | curl option to get HTTP status code only |
| `sleep 20` | Wait for app to fully start before health check |

---

## Errors Faced & Fixed

| Error | Cause | Fix |
|-------|-------|-----|
| HTTP 500 on health check | CORS config — `allowedOrigins("*")` with `allowCredentials(true)` not allowed in Spring Boot 3.x | Changed to `allowedOriginPatterns("*")` |
| Env variable not reaching Java | `-D` flags don't work same as env vars in Spring Boot | Used `export WEATHER_APIKEY=$WEATHER_APIKEY` |
| HTTP 404 on health check | Health check hitting `/` but app only has `/weather/{city}` | Changed health check URL to `/weather/Delhi` |

---

## How to Run

```bash
bash deploy_app.sh
```
