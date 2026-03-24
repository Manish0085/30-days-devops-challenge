#!/bin/bash

# =============================================================================
# setup_server.sh
# Remote Server Setup Script
# Author: Manish | Day 3 - 30 Days DevOps Challenge
# Description: SSH into EC2 and setup Docker + Java automatically
# =============================================================================

TARGET_IP="13.201.123.88"
PEM_FILE="/home/ubuntu/Shell-Scripting.pem"
SSH_USER="ubuntu"

log() {
    local level="$1"
    local message="$2"
    case "$level" in
        INFO)    echo -e "\e[0;36m[INFO]\e[0m  $message" ;;
        SUCCESS) echo -e "\e[0;32m[✓]\e[0m     $message" ;;
        WARN)    echo -e "\e[1;33m[WARN]\e[0m  $message" ;;
        ERROR)   echo -e "\e[0;31m[✗]\e[0m     $message" ;;
    esac
}


# 1. check_ssh() 

check_ssh() {
	log "INFO" "Testing SSH connection..."
	if ssh -i "$PEM_FILE" -o StrictHostKeyChecking=no "$SSH_USER@$TARGET_IP" "echo connected" &>/dev/null; then
		log "SUCCESS" "SSH connection successful"
    	else
        	log "ERROR" "SSH connection failed — check PEM file and IP"
        	exit 1
    	fi


}



# 2. setup_server()      — Remote commands chalao << EOF se
setup_server() {
	log "INFO" "Setting up remote server..."
	ssh -i "$PEM_FILE" -o StrictHostKeyChecking=no "$SSH_USER@$TARGET_IP" << EOF
		sudo apt update -y
		sudo apt install docker.io -y
		sudo apt install openjdk-17-jdk -y
		sudo systemctl start docker
		sudo systemctl enable docker
EOF
	log "SUCCESS" "Server setup complete!"	

}



# 3. verify_setup()      — Docker aur Java install hua check karo
verify_setup() {
	log "INFO" "Verifying remote setup..."
    	ssh -i "$PEM_FILE" -o StrictHostKeyChecking=no "$SSH_USER@$TARGET_IP" << EOF
        	docker --version
        	java -version
EOF
    log "SUCCESS" "Verification complete!"

}



# 4. main()
main() {
	check_ssh
	setup_server
	verify_setup
}




main "$@"
