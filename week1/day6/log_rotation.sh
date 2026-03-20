#!/bin/bash

# =============================================================================
# log_rotation.sh
# Log Rotation Script
# Author: Manish | Day 6 - 30 Days DevOps Challenge
# Description: Compress old logs, delete very old logs, rotate app log
# =============================================================================

# Variables
LOG_DIR="/home/ubuntu"
BACKUP_DIR="/home/ubuntu/log-backups"
APP_LOG="/home/ubuntu/app.log"
MAX_LOG_SIZE=10485760  # 10MB in bytes
COMPRESS_DAYS=7        # 7 din se purane compress karo
DELETE_DAYS=30         # 30 din se purane delete karo

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



# 1. create_backup_dir() 
create_backup_dir() {
	if [[ -d $BACKUP_DIR ]]; then
		log "WARN" "Backup dir already exists — skipping"
	else
		mkdir -p $BACKUP_DIR
	       	log "SUCCESS" "Backup directory created: $BACKUP_DIR"
        fi
}


# 2. compress_old_logs()
compress_old_logs() {
	
	log "INFO" "Compressing logs older than $COMPRESS_DAYS days..."	
	find "$LOG_DIR" -name "*.log" -mtime +$COMPRESS_DAYS | while read file; do
		gzip "$file"
		mv "$file.gz" "$BACKUP_DIR/"
		log "SUCCESS" "Compressed: $file"
	done
}


# 3. delete_old_logs()    

delete_old_logs() {
	log "INFO" "Deleting logs older than $DELETE_DAYS days..."
	find "$BACKUP_DIR" -name "*.gz" -mtime +$DELETE_DAYS | while read file; do
		rm -rf "$file"
		log "SUCCESS" "Deleted: $file"
	done

}




# 4. rotate_app_log()      — app.log size check karo, rotate karo
rotate_app_log() {

	log "INFO" "Rotating the log file of file..."
	local file_size
	file_size=$(wc -c < $APP_LOG)

	if [[ $file_size -gt $MAX_LOG_SIZE ]]; then
		mv $APP_LOG "app.log.$(date +%Y-%m-%d)"
		touch $APP_LOG
		log "SUCCESS" "App log rotated"
	else 
		log "INFO" "App log size OK — no rotation needed"
	fi

}



# 5. main()

main() {
    echo -e "\n\e[1m===== Log Rotation Report — $(date '+%Y-%m-%d %H:%M:%S') =====\e[0m\n"
    create_backup_dir
    compress_old_logs
    delete_old_logs
    rotate_app_log
    echo -e "\n\e[1m===== Log Rotation Complete =====\e[0m\n"
}



main "$@"
