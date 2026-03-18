#!/bin/bash

# =============================================================================
# deploy_app.sh
# Application Deployment Script
# Author: Manish | Day 4 - 30 Days DevOps Challenge
# Description: Deploy Spring Boot Weather App on EC2
# =============================================================================

JAR_PATH="/home/ubuntu/External-Api-0.0.1-SNAPSHOT.jar"
APP_PORT=8080
WEATHER_APIKEY="a4a002adb03b616cd08179adb3b7d4d8"    
LOG_FILE="/home/ubuntu/app.log"

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



# 1. check_jar()       — jar file exist karta hai check karo
check_jar() {
	if [[ -f "$JAR_PATH" ]]; then
		log "SUCCESS" "Jar file found: $JAR_PATH"
	else
		log "ERROR" "Jar file not found: $JAR_PATH"
		exit 1
	fi	
}



# 2. kill_existing()   — agar app already chal rahi hai toh kill karo
kill_existing() {
	local PID
	PID=$(lsof -t -i:$APP_PORT)

	if [[ -n "$PID" ]]; then
		log "WARN" "Killing existing process on port $APP_PORT — PID: $PID"
		kill -9 "$PID"
		log "SUCCESS" "Process killed"
	else
		log "INFO" "No existing process on port $APP_PORT"
	fi
}



# 3. deploy_app()      — jar run karo env vars ke saath
deploy_app() {
    log "INFO" "Deploying Weather App..."
    export WEATHER_APIKEY=$WEATHER_APIKEY
    export PORT=$APP_PORT
    java -jar "$JAR_PATH" > "$LOG_FILE" 2>&1 &
    log "SUCCESS" "App deployed — PID: $!"
}



# 4. health_check()    — curl se verify karo app running hai
health_check() {

	log "STEP" "Checking the App Health"
        sleep 20

        local status_code
	status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:$APP_PORT/weather/meerut)

        if [[ $status_code -eq 200 ]]; then
                log "SUCCESS" "App is running — HTTP $status_code"
        else
               	log "ERROR" "App failed to start — HTTP $status_code"
		exit 1
        fi
}


# 5. main()

main() {

	check_jar
	kill_existing
	deploy_app
	health_check

}

main "$@"
