#!/bin/bash

#########################################
## Variables

# utility
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M)
SPECIFY_TIME=$(date +%H%M)

# log
LOG_TIME="$DATE $TIME"
LOG_PATH="/root/${DATE}_${SPECIFY_TIME}_script_backup.log"
PRINT_LOG="$LOG_TIME $HOSTNAME"

# temporary
TEMP_PATH=/root

# gcloud storage
STORE_PATH=/mnt/project-prod-db-backup/redis

# redis
REDIS_PATH=/opt/redis
REDIS_DATA="dump.rdb appendonly.aof"

# mix
GCS_STRUCTURE="$STORE_PATH/$DATE/$SPECIFY_TIME"
GCS_DIR_HOSTNAME="$GCS_STRUCTURE/$HOSTNAME"

#########################################
## Function

check_gcs() {
  # Check '$STORE_PATH' exist
  if [ -e $STORE_PATH ] && [ -r $STORE_PATH ] && [ -w $STORE_PATH ]; then
      if [ ! -e $GCS_DIR_HOSTNAME ]; then
        # Create '$GCS_DIR_HOSTNAME' directory
        echo $PRINT_LOG: Create directory: $DATE/$SPECIFY_TIME/$HOSTNAME to $STORE_PATH >> $LOG_PATH
        mkdir -p $GCS_DIR_HOSTNAME
      else 
        echo $PRINT_LOG: $GCS_DIR_HOSTNAME Already exist >> $LOG_PATH
        exit 1
      fi
  else
      echo $PRINT_LOG: Please check $STORE_PATH exist and directory permission >> $LOG_PATH
      exit 1
  fi
}

backup_redis() {
  for data in $REDIS_DATA; do

      if [ -e $REDIS_PATH/$data ]; then

          # 1) Execute $data backup
          echo $PRINT_LOG: $REDIS_PATH/$data backup... >> $LOG_PATH
          cp $REDIS_PATH/$data $TEMP_PATH
          echo $PRINT_LOG: $REDIS_PATH/$data "done" >> $LOG_PATH
          
          # 2) Execute compress $data tar.gz format
          echo $PRINT_LOG: Execute $data compress >> $LOG_PATH
          cd $TEMP_PATH && tar -czf $data.gz $data --remove-files
          echo $PRINT_LOG: Compress "done" >> $LOG_PATH

          # 3) Move $data.gz file to $GCS_DIR_HOSTNAME
          echo $PRINT_LOG: Moving $data.gz file to $GCS_DIR_HOSTNAME >> $LOG_PATH
          mv $TEMP_PATH/$data.gz $GCS_DIR_HOSTNAME
          echo $PRINT_LOG: Moving "done" >> $LOG_PATH

      else
          echo $PRINT_LOG: $REDIS_PATH/$data Not exists
      fi
  done
}

#########################################
## Main

echo $PRINT_LOG: Redis Backup Script Running... >> $LOG_PATH

check_gcs
backup_redis

echo $PRINT_LOG: Redis Backup Script End >> $LOG_PATH

mv $LOG_PATH $GCS_DIR_HOSTNAME