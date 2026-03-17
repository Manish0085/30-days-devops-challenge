#!/bin/bash

# =============================================================================
# aws_setup.sh
# AWS CLI Setup & Verification Script
# Author: Manish | Day 2 - 30 Days DevOps Challenge
# Description: Configures AWS CLI and verifies connectivity
# =============================================================================

# Variables
REGION="ap-south-1"

# Log function — copy from Day 1
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



# 1. verify_aws_cli()     — aws installed hai ya nahi check karo
verify_aws_cli() {
    if command -v aws &>/dev/null; then
        log "SUCCESS" "AWS CLI installed → $(aws --version)"
    else
        log "ERROR" "AWS CLI not found — run setup_environment.sh first"
        exit 1
    fi
}




# 2. verify_credentials() — sts get-caller-identity se verify karo
verify_credentials() {
    if aws sts get-caller-identity &>/dev/null; then
        local account
        account=$(aws sts get-caller-identity --query 'Account' --output text)
        log "SUCCESS" "AWS credentials valid — Account: $account"
    else
        log "ERROR" "AWS credentials invalid — run aws configure"
        exit 1
    fi
}






# 3. show_config()        — current config print karo
show_config(){
	log "INFO" "Current AWS Configuration"
	aws configure list
}



# 4. main()               — sab call karo
main() {

verify_aws_cli
verify_credentials
show_config

}




main "$@"
