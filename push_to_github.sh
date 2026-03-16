#!/bin/bash

# =============================================================================
# push_to_github.sh
# GitHub Push Automation Script
# Author: Manish | Day 1 - 30 Days DevOps Challenge
# Description: Automates git init, add, commit and push to GitHub
# =============================================================================


REPO="https://Manish0085:${GITHUB_TOKEN}@github.com/Manish0085/30-days-devops-challenge.git"
COMMIT_MSG="${1:-"Day - $(date '+%Y-%m-%d') - Environment setup script"}"


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



init_repo() {
    if [[ -d .git ]]; then
        log "WARN" "Git already initialized — skipping"
        return 0
    else
        git init
        log "SUCCESS" "Git repository initialized"
    fi
}


git_add() {
    log "INFO" "Staging all files..."
    git add .
    log "SUCCESS" "Files staged successfully"
}



git_commit() {
    log "INFO" "Committing with message: $COMMIT_MSG"
    git commit -m "$COMMIT_MSG"
    log "SUCCESS" "Committed successfully"

}




git_push() {
    if ! git remote get-url origin &>/dev/null; then
        log "WARN" "Remote origin not found"
        log "INFO" "Adding remote origin..."
        git remote add origin "$REPO"

    fi
    
    if ! git rev-parse --abbrev-ref HEAD | grep -q "main"; then
        git branch -M main
    fi
    
    git push -u origin main
    log "SUCCESS" "Pushed to GitHub successfully"
}


main() {
    init_repo
    git_add
    git_commit
    git_push
}



main "$@"
