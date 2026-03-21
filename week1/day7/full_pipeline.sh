#!/bin/bash

# =============================================================================
# full_pipeline.sh
# Week 1 Complete DevOps Pipeline
# Author: Manish | Day 7 - 30 Days DevOps Challenge
# Description: End-to-End automation — EC2 launch to app deployment
# =============================================================================

# Script paths
DAY2_DIR="$HOME/30-days-devops-challenge/week1/day2"
DAY3_DIR="$HOME/30-days-devops-challenge/week1/day3"
DAY4_DIR="$HOME/30-days-devops-challenge/week1/day4"
DAY5_DIR="$HOME/30-days-devops-challenge/week1/day5"
DAY6_DIR="$HOME/30-days-devops-challenge/week1/day6"

log() {
    local level="$1"
    local message="$2"
    case "$level" in
        INFO)    echo -e "\e[0;36m[INFO]\e[0m  $message" ;;
        SUCCESS) echo -e "\e[0;32m[✓]\e[0m     $message" ;;
        WARN)    echo -e "\e[1;33m[WARN]\e[0m  $message" ;;
        ERROR)   echo -e "\e[0;31m[✗]\e[0m     $message" ;;
        STEP)    echo -e "\n\e[1;34m══════ $message ══════\e[0m" ;;
    esac
}

# 1. run_step()    
run_script() {

	local step_name="$1"
	local script_path="$2"

	log "STEP" "$step_name"

	if bash "$script_path"; then
		log "SUCCESS" "$step_name completed"
	else
		log "ERROR" "$step_name failed --> stopping pipeline"
		exit 1	
	fi

}


# 2. launch_ec2()       — Day 2 script call karo
launch_ec2(){

	run_script "EC2 Launch" "$DAY2_DIR/launch_ec2.sh"

}



# 3. setup_server() 
setup_server() {

	run_script "Server Setup" "$DAY3_DIR/setup_server.sh"
}

# 4. deploy_app()       
deploy_app() {

	run_script "App Deployment" "$DAY4_DIR/deploy_app.sh"
}



# 5. monitor_server()
monitor_server() {

	run_script "Monitor Server Health" "$DAY5_DIR/monitor.sh"
}

# 6. rotate_logs()      — Day 6 script call karo
rotate_logs(){

	run_script "Log Rotation" "$DAY6_DIR/log_rotation.sh"

}

# 7. main()             — sab call karo, final report print karo
main() {
	 echo -e "\n\e[1;34m"
    echo "╔════════════════════════════════════════╗"
    echo "║     Week 1 DevOps Pipeline Started     ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "\e[0m"

    launch_ec2
    setup_server
    deploy_app
    monitor_server
    rotate_logs

    echo -e "\n\e[1;32m"
    echo "╔════════════════════════════════════════╗"
    echo "║     Pipeline Complete! Week 1 Done!    ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "\e[0m"

}




main "$@"
