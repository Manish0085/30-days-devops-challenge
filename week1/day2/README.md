# Day 2 — AWS CLI Setup + EC2 Automation

## Goal
Write scripts to configure AWS CLI automatically and launch/manage EC2 instances from terminal — no console clicking.

---

## Scripts Built

| Script | Purpose |
|--------|---------|
| `aws_setup.sh` | Verify AWS CLI and credentials |
| `launch_ec2.sh` | Launch EC2, wait until running, print public IP |
| `ec2_manager.sh` | Start, stop, terminate, status check EC2 |

---

## What Each Script Does

### `aws_setup.sh`
```
Verify AWS CLI installed
    ↓
Verify credentials (sts get-caller-identity)
    ↓
Show current AWS config
```

### `launch_ec2.sh`
```
Launch EC2 instance
    ↓
Capture Instance ID
    ↓
Wait in loop until state = "running"
    ↓
Print Public IP
```

### `ec2_manager.sh`
```
Take Instance ID from user
    ↓
Show menu — start/stop/terminate/status
    ↓
Run selected action
```

---

## Commands Learned

### AWS CLI Commands
```bash
aws --version                          # Check AWS CLI version
aws configure                          # Setup credentials interactively
aws configure set region ap-south-1    # Set region programmatically
aws sts get-caller-identity            # Verify credentials are working
aws sts get-caller-identity --query 'Account' --output text   # Get account ID only

# EC2 Commands
aws ec2 run-instances \
    --image-id ami-xxxxxxxx \
    --instance-type t3.micro \
    --key-name my-key \
    --security-group-ids sg-xxxxxxxx \
    --count 1 \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=my-instance}]" \
    --query 'Instances[0].InstanceId' \
    --output text

aws ec2 describe-instances \
    --instance-ids i-xxxxxxxx \
    --query 'Reservations[0].Instances[0].State.Name' \
    --output text

aws ec2 describe-instances \
    --instance-ids i-xxxxxxxx \
    --query 'Reservations[0].Instances[0].PublicIpAddress' \
    --output text

aws ec2 start-instances --instance-ids i-xxxxxxxx
aws ec2 stop-instances --instance-ids i-xxxxxxxx
aws ec2 terminate-instances --instance-ids i-xxxxxxxx

# Find Key Pairs and Security Groups
aws ec2 describe-key-pairs --query 'KeyPairs[*].KeyName' --output text
aws ec2 describe-security-groups --query 'SecurityGroups[?GroupName==`default`].GroupId' --output text

# Add SSH rule to Security Group
aws ec2 authorize-security-group-ingress \
    --group-id sg-xxxxxxxx \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0
```

### While Loop (Waiting for EC2)
```bash
STATE="pending"
while [ "$STATE" != "running" ]; do
    STATE=$(aws ec2 describe-instances ...)
    sleep 5
done
```

### Read User Input
```bash
read -p "Enter Instance ID: " INSTANCE_ID
```

### Check if Variable is Empty
```bash
if [[ -n "$INSTANCE_ID" ]]; then   # -n = not empty
    echo "has value"
fi

if [[ -z "$INSTANCE_ID" ]]; then   # -z = is empty
    echo "empty"
fi
```

---

## Key Concepts Learned

| Concept | What it means |
|---------|--------------|
| `--query` | Extract specific field from AWS JSON output |
| `--output text` | Get plain text instead of JSON |
| `while` loop | Keep checking until condition is met |
| `-n` flag | Check if string is not empty |
| `read -p` | Take user input with a prompt |
| Security Group | AWS firewall — controls inbound/outbound traffic |
| Port 22 | SSH port — must be open to connect to EC2 |

---

## Errors Faced & Fixed

| Error | Cause | Fix |
|-------|-------|-----|
| SSH connection failed | Port 22 not open in Security Group | Added inbound rule for port 22 |
| 403 Permission denied | GitHub token missing `repo` scope | Regenerated token with `repo` scope |

---

## How to Run

```bash
bash aws_setup.sh
bash launch_ec2.sh
bash ec2_manager.sh
```
