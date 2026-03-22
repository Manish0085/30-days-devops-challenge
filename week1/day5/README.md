# Day 5 — Server Health Monitoring Script

## Goal
Write a script that automatically checks CPU, Memory, Disk usage and app status — alerts if anything crosses threshold.

---

## Script Built
**`monitor.sh`**

---

## What the Script Does

```
Check CPU usage
    ↓
Check Memory usage
    ↓
Check Disk usage
    ↓
Check if app is running on port 8080
    ↓
Print health report
```

---

## Commands Learned

### CPU Usage
```bash
top -bn1 | grep "Cpu(s)" | awk '{print $2}'

# top -bn1   = run top once in batch mode (non-interactive)
# grep        = filter only CPU line
# awk $2      = get second column (CPU usage %)
```

### Memory Usage
```bash
free -m | grep Mem | awk '{print ($3/$2)*100}'

# free -m     = show memory in MB
# grep Mem    = filter memory line
# awk ($3/$2) = used/total * 100 = percentage
```

### Disk Usage
```bash
df -h / | awk 'NR==2 {print $5}' | tr -d '%'

# df -h /     = disk usage of root partition
# NR==2       = second line (first is header)
# $5          = 5th column (Use%)
# tr -d '%'   = remove % sign
```

### App Status Check
```bash
lsof -t -i:8080    # Returns PID if app running, empty if not

if [[ -n "$app_status" ]]; then
    echo "Running — PID: $app_status"
else
    echo "Not running"
fi
```

### Threshold Based Alerting
```bash
CPU_THRESHOLD=80

if [[ ${cpu_usage} -gt $CPU_THRESHOLD ]]; then
    log "WARN" "CPU HIGH!"
else
    log "SUCCESS" "CPU OK"
fi
```

---

## Key Concepts Learned

| Concept | What it means |
|---------|--------------|
| `top -bn1` | Run top once in non-interactive batch mode |
| `awk '{print $2}'` | Print second column/word of output |
| `awk '{print ($3/$2)*100}'` | Math inside awk |
| `NR==2` | Second line in awk (skip header) |
| `tr -d '%'` | Delete specific character from output |
| `free -m` | Show memory usage in MB |
| `df -h` | Show disk usage in human readable format |
| `-gt` | Greater than comparison in bash |
| `-n` | Check if string is not empty |

---

## How to Run

```bash
bash monitor.sh
```

## Sample Output
```
[INFO]  Checking CPU usage...
[✓]     CPU Usage: 23% — OK
[INFO]  Checking memory usage...
[✓]     Memory Usage: 61% — OK
[INFO]  Checking Disk usage...
[✓]     Disk Usage: 45% — OK
[INFO]  Checking App Status...
[✓]     App is running — PID: 2088
```
