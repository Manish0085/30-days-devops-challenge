#!/bin/bash

# =============================================================================
# ecommerce_deploy.sh
# Full Stack Ecommerce Deployment Script
# Author: Manish | Day 14 - 30 Days DevOps Challenge
# Description: Deploy complete Ecommerce app using Docker Compose
# =============================================================================

COMPOSE_FILE="docker-compose.yml"
PROJECT_NAME="ecommerce"

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

# 1. check_compose()
check_compose() {
    if [[ -f "$COMPOSE_FILE" ]]; then
        log "SUCCESS" "Docker Compose file found: $COMPOSE_FILE"
    else
        log "ERROR" "Docker Compose file not found: $COMPOSE_FILE"
        exit 1
    fi
}

# 2. stop_existing()
stop_existing() {
    log "INFO" "Stopping existing containers..."
    docker compose down
    log "SUCCESS" "Containers stopped"
}

# 3. build_and_deploy()
build_and_deploy() {
    log "INFO" "Building and deploying all services..."
    if docker compose up --build -d; then
        log "SUCCESS" "App deployed successfully"
    else
        log "ERROR" "Deployment failed"
        exit 1
    fi
}

# 4. check_services()
check_services() {
    log "INFO" "Checking all services..."
    sleep 15
    for service in postgres backend frontend; do
        if docker compose ps "$service" | grep -q "Up"; then
            log "SUCCESS" "$service is running"
        else
            log "ERROR" "$service is not running"
        fi
    done
}

# 5. main()
main() {
    echo -e "\n\e[1;34m"
    echo "╔════════════════════════════════════════╗"
    echo "║    Ecommerce Full Stack Deployment     ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "\e[0m"

    check_compose
    stop_existing
    build_and_deploy
    check_services

    echo -e "\n\e[1;32m"
    echo "╔════════════════════════════════════════╗"
    echo "║     Week 2 Complete! App is Live! 🚀   ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "\e[0m"
}

main "$@"
