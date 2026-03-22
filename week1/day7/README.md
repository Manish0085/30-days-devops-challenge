# Day 7 — Week 1 End-to-End Pipeline (Final Project)

## Goal
Build a master script that ties together all Week 1 scripts into one complete automated DevOps pipeline.

---

## Script Built
**`full_pipeline.sh`**

---

## What the Script Does

```
╔════════════════════════════════════════╗
║     Week 1 DevOps Pipeline Started     ║
╚════════════════════════════════════════╝
         ↓
Step 1: Launch EC2 (launch_ec2.sh)
         ↓
Step 2: Setup Server (setup_server.sh)
         ↓
Step 3: Deploy App (deploy_app.sh)
         ↓
Step 4: Monitor Health (monitor.sh)
         ↓
Step 5: Rotate Logs (log_rotation.sh)
         ↓
╔════════════════════════════════════════╗
║     Pipeline Complete! Week 1 Done!    ║
╚════════════════════════════════════════╝
```

---

## Key Design Pattern — `run_script()`

The most important function in this script — runs any script and stops the entire pipeline if it fails:

```bash
run_script() {
    local step_name="$1"
    local script_path="$2"

    log "STEP" "$step_name"

    if bash "$script_path"; then
        log "SUCCESS" "$step_name completed"
    else
        log "ERROR" "$step_name failed — stopping pipeline"
        exit 1
    fi
}
```

Every step uses this — clean, reusable, fail-fast.

---

## Commands Learned

### Calling Scripts from Scripts
```bash
bash "$script_path"          # Run another bash script
source "$script_path"        # Run and import its variables too
```

### Exit Codes in Pipeline
```bash
if bash "script.sh"; then    # Script returned 0 = success
    echo "success"
else                         # Script returned non-0 = failed
    exit 1                   # Stop pipeline
fi
```

### Colored Box Output
```bash
echo -e "\e[1;34m"
echo "╔════════════════════════════════════════╗"
echo "║     Week 1 DevOps Pipeline Started     ║"
echo "╚════════════════════════════════════════╝"
echo -e "\e[0m"
```

---

## Key Concepts Learned

| Concept | What it means |
|---------|--------------|
| Script reuse | Call existing scripts — don't rewrite |
| Fail-fast | Stop pipeline immediately on first failure |
| Exit codes | 0 = success, non-zero = failure |
| Pipeline | Series of steps where each depends on previous |
| `bash "script"` | Run another script as child process |

---

## Week 1 Complete — What I Built

| Script | What it does |
|--------|-------------|
| `setup_environment.sh` | Install Git, Docker, AWS CLI, Java automatically |
| `aws_setup.sh` | Verify AWS CLI and credentials |
| `launch_ec2.sh` | Launch EC2, wait until running, get IP |
| `ec2_manager.sh` | Start, stop, terminate EC2 instances |
| `setup_server.sh` | SSH into EC2, install Docker + Java remotely |
| `deploy_app.sh` | Deploy Spring Boot Weather API on EC2 |
| `monitor.sh` | Monitor CPU, Memory, Disk, App health |
| `log_rotation.sh` | Compress, archive, delete, rotate logs |
| `full_pipeline.sh` | Run entire pipeline end-to-end |
| `push_to_github.sh` | Automate git add, commit, push |

---

## Resume Line

> *Built a complete shell scripting automation pipeline — EC2 provisioning, remote server configuration, Spring Boot app deployment, health monitoring, and log rotation — fully automated using Bash and AWS CLI.*

---

## How to Run

```bash
bash week1/day7/full_pipeline.sh
```
