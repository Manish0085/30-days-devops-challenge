#!/bin/bash

# =============================================================================
# docker_deploy.sh
# Docker Deployment Automation Script
# Author: Manish | Day 13 - 30 Days DevOps Challenge
# Description: Pull, Stop, Deploy and Health check Docker container
# =============================================================================

IMAGE="manishk57107/news-app:v1"
CONTAINER_NAME="news-app"
HOST_PORT=8081
CONTAINER_PORT=8080
NEWS_API_KEY=db0d86ded6cd4f1d9d01a21b8b5abd60

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


 pull_image() {
	log "INFO" "Pulling latest image..."

	if docker pull $IMAGE; then
		log "SUCCESS" "Image pulled successfully"
	else
		log "ERROR" "Image pull failed"
	fi
}



stop_container() {
	log "INFO" "Stopping the container if running..."
	local container_id=$(docker ps -q --filter "name=$CONTAINER_NAME")
	if [[ -n ${container_id} ]]; then
		docker stop ${container_id}
		log "SUCCESS" "Conatiner is stopped"
	else
		log "WARN" "No Conatiner found with name $CONTAINER_NAME"
	fi	

}


start_container() {
    local container_id=$(docker ps -q --filter "name=$CONTAINER_NAME")
    if [[ -n "$container_id" ]]; then
        log "WARN" "Container already running — $CONTAINER_NAME"
    else
        log "INFO" "Starting container..."
        docker run -d -p $HOST_PORT:$CONTAINER_PORT --name $CONTAINER_NAME -e NEWS_API_KEY=${NEWS_API_KEY} "$IMAGE"
        log "SUCCESS" "Container started — $CONTAINER_NAME"
    fi
}



 health_check() {
	log "INFO" "Running the health check"
	sleep 20
	local status_code
	status_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:$HOST_PORT/news/lpg)
	if [[ ${status_code} -eq 200 ]]; then
		log "SUCCESS" "App is healthy -- HTTP status $status_code"
	else
		log "ERROR" "App is not healthy — HTTP $status_code"
		exit 1
	fi
	 
}
# 5. main()
main() {
    echo -e "\n\e[1;34m"
    echo "╔════════════════════════════════════════╗"
    echo "║      Docker Deployment Started         ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "\e[0m"

    pull_image
    stop_container
    start_container
    health_check

    echo -e "\n\e[1;32m"
    echo "╔════════════════════════════════════════╗"
    echo "║      Deployment Complete! 🚀           ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "\e[0m"
}


main "$@"
