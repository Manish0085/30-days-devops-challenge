#!/bin/bash

# =============================================================================
# ec2_manager.sh
# EC2 Instance Manager Script
# Author: Manish | Day 2 - 30 Days DevOps Challenge
# Description: Start, Stop, Terminate and Status check EC2 instances
# =============================================================================

INSTANCE_ID=""  # script chalate waqt user se lenge

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

# 1. get_instance_id()
get_instance_id() {
	read -p "Enter the instance Id: " INSTANCE_ID

}



# 2. status_instance() 
check_status() {
    local status
    status=$(aws ec2 describe-instances \
        --instance-ids "$INSTANCE_ID" \
        --query 'Reservations[0].Instances[0].State.Name' \
        --output text)
    log "INFO" "Instance $INSTANCE_ID status: $status"
}



start_instance() {
    log "INFO" "Starting instance: $INSTANCE_ID"
    aws ec2 start-instances --instance-ids "$INSTANCE_ID" &>/dev/null
    log "SUCCESS" "Instance started successfully"
}




# 3. stop_instance() 
stop_instance() {
    log "INFO" "Stopping instance: $INSTANCE_ID"
    aws ec2 stop-instances --instance-ids "$INSTANCE_ID" &>/dev/null
    log "SUCCESS" "Instance stopped successfully"
}




# 4. terminate_instance()
terminate_instance() {
    log "INFO" "Terminating instance: $INSTANCE_ID"
    aws ec2 terminate-instances --instance-ids "$INSTANCE_ID" &>/dev/null
    log "SUCCESS" "Instance terminated successfully"
}



show_menu() {
    echo ""
    echo "========= EC2 Manager ========="
    echo "1. Start Instance"
    echo "2. Stop Instance"
    echo "3. Terminate Instance"
    echo "4. Check Status"
    echo "5. Exit"
    echo "==============================="
}    


main() {
    get_instance_id

    while true; do
        show_menu
        read -p "Choose an option: " choice

        case $choice in
            1) start_instance ;;
            2) stop_instance ;;
            3) terminate_instance ;;
            4) check_status ;;
            5) log "INFO" "Exiting..."; break ;;
            *) log "ERROR" "Invalid option" ;;
        esac
    done
}






main "$@"
