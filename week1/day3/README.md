# Day 3 — Remote Server Setup via SSH

## Goal
Write a script that SSHs into a remote EC2 instance and automatically installs Docker and Java — no manual login required.

---

## Script Built
**`setup_server.sh`**

---

## What the Script Does

```
Test SSH connection
    ↓
SSH into remote EC2
    ↓
Run commands via heredoc (EOF)
    - apt update
    - Install Docker
    - Install Java 17
    - Start Docker service
    ↓
Verify Docker and Java installed remotely
```

---

## Commands Learned

### SSH Commands
```bash
# Connect to EC2
ssh -i "key.pem" ubuntu@EC2_IP

# Run single command remotely
ssh -i "key.pem" ubuntu@EC2_IP "echo connected"

# Avoid interactive fingerprint prompt
ssh -i "key.pem" -o StrictHostKeyChecking=no ubuntu@EC2_IP "command"

# Run multiple commands remotely using heredoc
ssh -i "$PEM_FILE" -o StrictHostKeyChecking=no "$SSH_USER@$TARGET_IP" << EOF
    sudo apt update -y
    sudo apt install docker.io -y
    sudo systemctl start docker
EOF
```

### SCP — File Transfer
```bash
# Copy file from local to EC2
scp -i "key.pem" localfile.txt ubuntu@EC2_IP:/home/ubuntu/

# Copy file from EC2 to local
scp -i "key.pem" ubuntu@EC2_IP:/home/ubuntu/file.txt ./local/
```

### PEM File Permission
```bash
chmod 400 key.pem    # Must be 400 — SSH refuses if permissions are too open
```

---

## Key Concepts Learned

| Concept | What it means |
|---------|--------------|
| Heredoc `<< EOF` | Send multiple commands to SSH in one connection |
| `StrictHostKeyChecking=no` | Skip fingerprint prompt — required for scripts |
| `chmod 400` | PEM file must have strict permissions for SSH |
| `scp` | Secure copy — transfer files over SSH |
| Remote execution | Run commands on another machine from script |

---

## Errors Faced & Fixed

| Error | Cause | Fix |
|-------|-------|-----|
| SSH connection failed | Port 22 not open in Security Group | Added inbound SSH rule |
| SSH refused | PEM file permissions too open | `chmod 400 key.pem` |
| EOF not closing | Closing EOF had spaces/indent before it | Moved EOF to column 1 (no spaces) |

---

## Important Note about EOF
```bash
# WRONG — EOF indented, bash can't find closing tag
ssh user@host << EOF
    commands here
    EOF          ← indented — WRONG

# CORRECT — EOF must be at start of line
ssh user@host << EOF
    commands here
EOF              ← column 1 — CORRECT
```

---

## How to Run

```bash
bash setup_server.sh
```
