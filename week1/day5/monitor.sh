#!/bin/bash

# =============================================================================
# monitor.sh
# Server Health Monitoring Script
# Author: Manish | Day 5 - 30 Days DevOps Challenge
# Description: Monitor CPU, Memory, Disk and App health
# =============================================================================

# Thresholds — agar inse zyada ho toh alert
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80
APP_PORT=8080

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

# 1. check_cpu()
check_cpu() {
	log "INFO" "Checking CPU usage..."
	local cpu_usage
	cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')
	if [[ ${cpu_usage} -gt $CPU_THRESHOLD ]]; then
		log "WARN" "CPU Usage: $cpu_usage% — HIGH!"
	else 
		log "SUCCESS" "CPU Usage: $cpu_usage% — OK"	
	fi

}


# 2. check_memory()
check_memory() {
	log "INFO" "Checking memory usage..."
	local memory_usage
	memory_usage=$(free -m | grep Mem | awk '{print ($3/$2)*100}')
	if [[ ${memory_usage} -gt $MEMORY_THRESHOLD ]]; then
		log "WARN" "Memory Usage: $memory_usage% — HIGH!"
	else
		log "SUCCESS" "Memory Usage: $memory_usage% — OK"
	fi


}



# 3. check_disk()
check_disk() {

	log "INFO" "Checking Disk usage..."
	local disk_usage
	disk_usage=$(df -h | awk 'NR==2 {print $5}' | tr -d '%')
	if [[ ${disk_usage} -gt $DISK_THRESHOLD ]]; then
		log "WARN" "Disk Usage: $disk_usage% — HIGH!"
	else
		log "SUCCESS" "Disk Usage: $disk_usage% — OK"
	fi


}



check_app() {
	log "INFO" "Checking App Status..."
	local app_status
	app_status=$(lsof -t -i:$APP_PORT)
	if [[ -n ${app_status} ]]; then
		log "SUCCESS" "App is running — PID: $app_status"
	else
		log "ERROR" "App is not running on port $APP_PORT"
	fi

}



# 5. main()

main() {
	check_cpu
	check_memory
	check_disk
	check_app

}

main "$@"
