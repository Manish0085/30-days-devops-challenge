# Week 1 — Shell Scripting for DevOps Automation

> **Goal:** Automate real DevOps tasks using Bash — from environment setup to EC2 provisioning, app deployment, monitoring, and log management.

---

## Week 1 Overview

| Day | Task | Script |
|-----|------|--------|
| Day 1 | DevOps environment setup automation | `setup_environment.sh` |
| Day 2 | AWS CLI setup + EC2 launch + EC2 manager | `aws_setup.sh`, `launch_ec2.sh`, `ec2_manager.sh` |
| Day 3 | Remote server setup via SSH | `setup_server.sh` |
| Day 4 | Spring Boot Weather App deployment | `deploy_app.sh` |
| Day 5 | Server health monitoring | `monitor.sh` |
| Day 6 | Log rotation and archiving | `log_rotation.sh` |
| Day 7 | End-to-end pipeline (Week 1 final project) | `full_pipeline.sh` |

---

## What I Built This Week

A complete shell scripting automation pipeline that:

1. Sets up a fresh DevOps environment automatically
2. Configures AWS CLI and launches EC2 instances from script
3. SSHs into remote EC2 and installs Docker + Java automatically
4. Deploys a real Spring Boot Weather API on EC2
5. Monitors server health (CPU, Memory, Disk, App)
6. Rotates and archives log files automatically
7. Ties everything into one master pipeline script

---

## Folder Structure

```
week1/
├── day1/
│   └── setup_environment.sh
├── day2/
│   ├── aws_setup.sh
│   ├── launch_ec2.sh
│   └── ec2_manager.sh
├── day3/
│   └── setup_server.sh
├── day4/
│   └── deploy_app.sh
├── day5/
│   └── monitor.sh
├── day6/
│   └── log_rotation.sh
└── day7/
    └── full_pipeline.sh
```

---

## Key Concepts Learned This Week

- Bash functions, variables, conditionals, loops
- Error handling with `trap`
- Logging with timestamps
- AWS CLI — configure, EC2 launch, describe, terminate
- SSH remote command execution with heredoc (`<< EOF`)
- SCP — file transfer between local and EC2
- Process management — `lsof`, `kill -9`
- System monitoring — `top`, `free`, `df`, `awk`
- Log rotation — `find`, `gzip`, `wc`
- Idempotent scripts — safe to run multiple times

---

## How to Run Full Pipeline

```bash
bash week1/day7/full_pipeline.sh
```

This single command runs the entire Week 1 pipeline end-to-end.
