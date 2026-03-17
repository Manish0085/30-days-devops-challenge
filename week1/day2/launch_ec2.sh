#!/bin/bash

# =============================================================================
# launch_ec2.sh
# EC2 Instance Launch Script
# Author: Manish | Day 2 - 30 Days DevOps Challenge
# Description: Launches EC2 instance and waits until running
# =============================================================================

# Variables —
INSTANCE_ID=""
AMI_ID="ami-0f58b397bc5c1f2e8"   # Ubuntu 22.04 ap-south-1
INSTANCE_TYPE="t3.micro"
KEY_NAME="Shell-Scripting"          # apna key pair naam daalo
SECURITY_GROUP="sg-0c5ea97461394e6de"    # apna SG ID daalo
INSTANCE_NAME="devops-challenge-day2"

# Log function same as before
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

launch_instance() {

	log "INFO" "Launching EC2 instance..."
	INSTANCE_ID=$(aws ec2 run-instances \
        	--image-id "$AMI_ID" \
        	--instance-type "$INSTANCE_TYPE" \
        	--key-name "$KEY_NAME" \
        	--security-group-ids "$SECURITY_GROUP" \
        	--count 1 \
        	--tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME}]" \
        	--query 'Instances[0].InstanceId' \
        	--output text)
    log "SUCCESS" "Instance launched — ID: $INSTANCE_ID"


}



wait_for_running() {
	log "INFO" "Waiting for instance to enter 'running' state..."


	STATE="pending"
	while [ "$STATE" != "running" ]; do  
		
		STATE=$(aws ec2 describe-instances \
            		--instance-ids "$INSTANCE_ID" \
            		--query 'Reservations[0].Instances[0].State.Name' \
            		--output text)

        	log "INFO" "Current state: $STATE"

		sleep 5
	done

	log "SUCCESS" "Instance is now running!"
	
}



get_public_ip() {
	log "INFO" "Fetching public IP..."
	PUBLIC_IP=$(aws ec2 describe-instances \
    		--instance-ids "$INSTANCE_ID" \
    		--query 'Reservations[0].Instances[0].PublicIpAddress' \
		--output text)

	log "SUCCESS" "Public IP: $PUBLIC_IP"
}



main() {
	launch_instance
	wait_for_running
	get_public_ip
}



main "$@"

