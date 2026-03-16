#!/bin/bash

# ========================================================================================
# setup_environment.sh
# Devops Environment setup script
# Author: MAnish Kumar | Day 1 - 30 Days Devops Challange
# ========================================================================================
# What the script does:
# 	- Detects OS automatically
# 	- Install Git, Docker, AWS Cli, Java
# 	- Validate every installation
# 	- Logs everytime with timestamps
# 	- Handle errors properly (doesn't silently fail)
# ========================================================================================




# ----------------------------------------------------------------------------------------
# Section 1: Colors &  Formatting
# ----------------------------------------------------------------------------------------


RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'



LOG_DIR="$HOME/devops-logs"
LOG_FILE="$LOG_DIR/setup_$(date +%Y%m%d_%H%M%S).log"


mkdir -p "$LOG_DIR"


log () {
	local level="$1"
	local message="$2"
	local timestamp
	timestamp=$(date '+%Y-%m-%d %H:%M:%S')


	echo "[$timesatmp] [$llevel] $message" >> "$LOG_FILE"


	case "$level" in
		INFO) echo -e "${CYAN}[INFO]${RESET}   $message" ;;
		SUCCESS) echo -e "${GREEN}[SUCCESS]${RESET}   $message" ;;
		WARN) echo -e "${YELLOW}[WARN]${RESET}   $message" ;;
		ERROR) echo -e "${RED}[ERROR]${RESET}   $message" ;;
		INFO) echo -e "\n${BOLD}${BLUE}-------- $message -----------${RESET}" ;;
	esac

}


handle_error() {
	local exit_code=$?
	local line-number=$1

	log "ERROR" "Script failed at line $line_number with exit code $exit_code"
	log "ERROR" "Check full log at: $LOG_FILE"

	exit 1
	
}

trap 'handle_error $LINENO' ERR


command_exists() {
	command -v "$1" &>/dev/null
}


check_root () {
	if [[ $EUID -ne 0 ]]; then
		log "ERROR" "This script must be run with sudo"
        	log "ERROR" "Usage: sudo bash setup_environment.sh"
        	exit 1
	fi
}




detect_os() {
	if [[ -f /etc/os-release ]]; then
		source /etc/os-release
		OS=$ID
		OS_VERSION=$VERSION_ID
	else 
		log "ERROR" "Cannot detect OS. /etc/os-release not found."
        	exit 1
    	fi

    	log "INFO" "Detected OS: $OS $OS_VERSION"
}



install_package() {
	local package="$1"
	log "INFO" "Installing $package..."

	case "$OS" in
		ubuntu|debian)
			apt-get install -y "$package" >> "$LOG_FILE" 2>&1
			;;
		centos|rhel|fedora)
			yum install -y "$package" >> "$LOG_FILE" 2>&1
			;;
		*)
			log "ERROR" "Unsupported OS: $OS"
            		exit 1
            		;;
	esac

	log "SUCCESS" "$package installed"
}



update_system() {
	log "STEP" "Updating System Packages"
 
	log "INFO" "Running system update (this may take a minute)..."

	case "$OS" in 
		ubuntu|debian)
			apt-get update -y >> "$LOG_FILE" 2>&1
			apt-get upgrade -y >> "$LOG_FILE" 2>&1
			;;
		centos|rhel)
			yum update -y >> "$LOG_FILE" 2>&1
			;;
		esac

	log "SUCCESS" "System updated successfully"

}




install_git() {
	log "STEP" "Setting Up Git"

	if command_exists git; then
		local version
		version=$(git --version)
		log "WARN" "Git already installed: $version — skipping"
        	return 0
	fi

	install_package git


	if command_exists git; then
		log "SUCCESS" "Git version: $(git --version)"
	else
		log "ERROR" "Git installation failed"
       		exit 1
	fi	
}




install_java() {
	
	log "STEP" "Setting Up Java (OpenJDK 17)"


	if command_exists java; then
		local version
		version=$(java -version)
		log "WARN" "Java already installed: $version — skipping"
        	return 0
	fi

	install_package openjdk-17-jdk

	local java_path
	java_path=$(readlink -f /usr/bin/java | sed 's|/bin/java||')


	if ! grep -q "JAVA_HOME" /etc/environment; then
		echo "JAVA_HOME=$java_path" >> /etc/environment
        	log "INFO" "JAVA_HOME set to: $java_path"
    	fi


	export JAVA_HOME="$java_path"
	export PATH="$JAVA_HOME/bin:$PATH"

	if command_exists; then
		log "SUCCESS" "Java version: $(java -version 2>&1 | head -1)"
    	else
        	log "ERROR" "Java installation failed"
        	exit 1
	fi	
}



install_docker() {


	log "STEP" "Setting Up Docker"


	if command_exists docker; then
                local version
                version=$(docker --version)
                log "WARN" "Docker already installed: $version — skipping"
                return 0
        fi

	log "INFO" "Adding Docker official GPG key and repository..."

	apt-get install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release >> "$LOG_FILE" 2>&1


	install -m 0755 -d /etc/apt/keyrings
    	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
        gpg --dearmor -o /etc/apt/keyrings/docker.gpg >> "$LOG_FILE" 2>&1
    	chmod a+r /etc/apt/keyrings/docker.gpg



	echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
        https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | \
        tee /etc/apt/sources.list.d/docker.list >> "$LOG_FILE" 2>&1

	apt-get update -y >> "$LOG_FILE" 2>&1

	apt-get install -y \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin >> "$LOG_FILE" 2>&1



	systemctl start docker
	systemctl enable docker >> "$LOG_FILE" 2>&1


	local ACTUAL_USER="${SUDO_USER:-$USER}"
	if id "$ACTUAL_USER" &>/dev/null; then
		usermod -aG docker "$ACTUAL_USER"
		log "INFO" "Added $ACTUAL_USER to docker group (re-login to take effect)"

	fi

	if command_exists docker; then
        	log "SUCCESS" "Docker version: $(docker --version)"
        	log "SUCCESS" "Docker Compose version: $(docker compose version)"
   	else
        	log "ERROR" "Docker installation failed"
        	exit 1
    	fi


}



install_aws_cli() {

	log "STEP" "Setting Up AWS CLI v2"
 
	if command_exists aws; then
        	local version
        	version=$(aws --version)
        	log "WARN" "AWS CLI already installed: $version — skipping"
        	return 0
    	fi



	log "INFO" "Downloading AWS CLI v2 installer..."

	install_package unzip


	local tmp_dir
	tmp_dir=$(mktemp -d)


	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
        -o "$tmp_dir/awscliv2.zip" >> "$LOG_FILE" 2>&1

    	log "INFO" "Extracting and installing AWS CLI..."
    	unzip -q "$tmp_dir/awscliv2.zip" -d "$tmp_dir"
    	"$tmp_dir/aws/install" >> "$LOG_FILE" 2>&1


	rm -rf "$tmp_dir"
	
	if command_exists aws; then
		log "SUCCESS" "AWS CLI version: $(aws --version)"
    	else
        	log "ERROR" "AWS CLI installation failed"
        	exit 1
    	fi	
}



run_validation() {
	log "STEP" "Running Post-Install Validation (Smoke Test)"

	local all_good=true

	local tools=("git" "java" "aws" "docker")


	for tool in "${tools[@]}"; do
		if command_exists "$tool"; then
			log "SUCCESS" "$tool → $(command -v "$tool")"

		else
			log "ERROR" "$tool → NOT FOUND"
		 	all_good=false
		fi
	done



	if systemctl is-active --quiet docker; then 
		log "SUCCESS" "Docker service is running"
	else
		log "WARN" "Docker service is not running — try: sudo systemctl start docker"
		all_good=false

	fi


	if $all_good; then
		log "SUCCESS" "All tools installed and validated successfully"
		return 0
	else
		log "ERROR" "Some tools failed validation — check log: $LOG_FILE"
		return 1
	fi

}




print_summary() {
    echo -e "\n${BOLD}${GREEN}════════════════════════════════════════${RESET}"
    echo -e "${BOLD}${GREEN}   DevOps Environment Setup Complete!   ${RESET}"
    echo -e "${BOLD}${GREEN}════════════════════════════════════════${RESET}\n"

    echo -e "${CYAN}Installed Tools:${RESET}"
    command_exists git    && echo -e "  ${GREEN}✓${RESET} Git        $(git --version)"
    command_exists java   && echo -e "  ${GREEN}✓${RESET} Java       $(java -version 2>&1 | head -1)"
    command_exists docker && echo -e "  ${GREEN}✓${RESET} Docker     $(docker --version)"
    command_exists aws    && echo -e "  ${GREEN}✓${RESET} AWS CLI    $(aws --version)"

    echo -e "\n${CYAN}Log file saved at:${RESET}"
    echo -e "  $LOG_FILE"

    echo -e "\n${YELLOW}Next Steps:${RESET}"
    echo -e "  1. Log out and back in for Docker group permissions to apply"
    echo -e "  2. Run: aws configure   (to set up your AWS credentials)"
    echo -e "  3. Run: docker run hello-world   (to verify Docker works)"
    echo -e "\n${BOLD}Day 1 of 30 — Done. Push this to GitHub! 🚀${RESET}\n"
}



main() {
    clear
    echo -e "${BOLD}${BLUE}"
    echo "  ██████╗ ███████╗██╗   ██╗ ██████╗ ██████╗ ███████╗"
    echo "  ██╔══██╗██╔════╝██║   ██║██╔═══██╗██╔══██╗██╔════╝"
    echo "  ██║  ██║█████╗  ██║   ██║██║   ██║██████╔╝███████╗"
    echo "  ██║  ██║██╔══╝  ╚██╗ ██╔╝██║   ██║██╔═══╝ ╚════██║"
    echo "  ██████╔╝███████╗ ╚████╔╝ ╚██████╔╝██║     ███████║"
    echo "  ╚═════╝ ╚══════╝  ╚═══╝   ╚═════╝ ╚═╝     ╚══════╝"
    echo -e "${RESET}"
    echo -e "${CYAN}  Environment Setup Script | 30 Days DevOps Challenge${RESET}"
    echo -e "${CYAN}  Log: $LOG_FILE${RESET}\n"
 
    # Step 0: Must run as root
    check_root
 
    # Step 1: Detect OS
    detect_os
 
    # Step 2: Update system
    update_system
 
    # Step 3: Install all tools
    install_git
    install_java
    install_docker
    install_aws_cli
 
    # Step 4: Validate everything
    run_validation
 
    # Step 5: Print summary
    print_summary
}
 

main "$@"








	
