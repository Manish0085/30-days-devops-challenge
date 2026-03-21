# Day 1 — DevOps Environment Setup Automation

## Goal
Write a production-style Bash script that automatically installs Git, Docker, AWS CLI, and Java on a fresh Ubuntu EC2 instance.

---

## Script Built
**`setup_environment.sh`**

A fully automated environment setup script with:
- OS detection
- Timestamped logging to file
- Error handling with `trap`
- Post-install smoke test (validation)
- Color-coded terminal output

---

## What the Script Does

```
Run script
    ↓
Check root/sudo
    ↓
Detect OS (ubuntu/debian/centos)
    ↓
Update system packages
    ↓
Install Git
    ↓
Install Java 17
    ↓
Install Docker (official repo method)
    ↓
Install AWS CLI v2
    ↓
Run smoke test (validate all tools)
    ↓
Print summary report
```

---

## Commands Learned

### Basic Script Commands
```bash
#!/bin/bash              # Shebang — tells system to use bash
chmod +x script.sh       # Make script executable
sudo bash script.sh      # Run script with sudo
```

### Variables & Colors
```bash
RED='\033[0;31m'         # ANSI color code — red
GREEN='\033[0;32m'       # ANSI color code — green
RESET='\033[0m'          # Reset color back to normal
echo -e "${GREEN}text${RESET}"  # -e flag to interpret color codes
```

### Functions
```bash
my_function() {
    local var="$1"       # local — variable only lives inside function
    echo "$var"          # $1 = first argument passed to function
}
my_function "hello"      # Call function with argument
```

### Error Handling
```bash
trap 'handle_error $LINENO' ERR   # Catch any error automatically
$?        # Exit code of last command (0=success, 1=fail)
$LINENO   # Current line number in script
exit 1    # Stop script with error
exit 0    # Stop script with success
```

### OS Detection
```bash
source /etc/os-release   # Load OS info as variables
echo $ID                 # ubuntu / debian / centos
echo $VERSION_ID         # 22.04 / 20.04 etc
```

### Logging to File
```bash
echo "message" >> file.log    # Append to file
echo "message" > file.log     # Overwrite file
command >> file.log 2>&1      # Send output + errors to log file
```

### Checking Commands
```bash
command -v git            # Returns path if git exists
command -v git &>/dev/null  # Throw away output, just check exit code
```

### Case Statement
```bash
case "$OS" in
    ubuntu|debian)
        apt-get install -y package
        ;;
    centos|rhel)
        yum install -y package
        ;;
esac
```

### Docker Installation (Official Method)
```bash
# Add GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Add Docker repo
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list

# Install Docker Engine
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Start Docker service
systemctl start docker
systemctl enable docker
```

### AWS CLI v2 Installation
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
./aws/install
```

---

## Key Concepts Learned

| Concept | What it means |
|---------|--------------|
| `trap` | Automatically catch errors — like try-catch in Java |
| `$?` | Exit code of last command |
| `$LINENO` | Current line number |
| `local` | Variable scope inside function only |
| `source` | Load another file's variables into current script |
| `2>&1` | Send stderr to stdout |
| `&>/dev/null` | Throw away all output |
| Idempotency | Script is safe to run multiple times |
| Smoke test | Quick validation after installation |

---

## Errors Faced & Fixed

| Error | Cause | Fix |
|-------|-------|-----|
| Log file not found | `sudo` changes `$HOME` to `/root` | `sudo mkdir -p /root/devops-logs` |
| Java installation failed | `readlink` chain returned empty path | Used `readlink -f /usr/bin/java \| sed 's\|/bin/java\|\|'` |
| Validation showed tools NOT FOUND | Missing `$` before variable — `command_exists tool` instead of `command_exists "$tool"` | Added `$` before variable |

---

## How to Run

```bash
sudo bash setup_environment.sh
```
