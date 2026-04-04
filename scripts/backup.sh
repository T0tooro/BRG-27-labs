#!/bin/bash

# Backup script with logging
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_DIR=~/backups
LOG_FILE=~/backups/backup.log

mkdir -p $BACKUP_DIR

echo "[$DATE] Starting backup..." >> $LOG_FILE
tar -czf $BACKUP_DIR/backup_$DATE.tar.gz ~/test-folder 2>> $LOG_FILE
echo "[$DATE] Backup completed: backup_$DATE.tar.gz" >> $LOG_FILE
echo "[$DATE] Disk usage: $(df -h ~ | tail -1)" >> $LOG_FILE
