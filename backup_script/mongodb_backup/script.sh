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
STORE_PATH=/mnt/project-prod-db-backup/mongodb

# mongo
MONGO_HOST=localhost
MONGO_PORT='27017'
MONGO_USERNAME=global
MONGO_PASSWORD=password
MONGO_DATABASE=global_mongo_db

# mix
GCS_STRUCTURE="$STORE_PATH/$DATE/$SPECIFY_TIME"
GCS_DIR_HOSTNAME="$GCS_STRUCTURE/$HOSTNAME"

#########################################
## Function

check_gcs() {
  # Check '$STORE_PATH' exist
  if [ -e $STORE_PATH ] && [ -r $STORE_PATH ] && [ -w $STORE_PATH ]; then
      if [ ! -e $GCS_STRUCTURE ]; then
        # Create '$GCS_STRUCTURE' directory
        echo $PRINT_LOG: Create directory: $DATE/$SPECIFY_TIME to $STORE_PATH >> $LOG_PATH
        mkdir -p $GCS_STRUCTURE
      else 
        echo $PRINT_LOG: $GCS_STRUCTURE Already exist >> $LOG_PATH
        exit 1
      fi
  else
      echo $PRINT_LOG: Please check $STORE_PATH exist and directory permission >> $LOG_PATH
      exit 1
  fi
}

backup_mongodb() {
  # Create '$GCS_DIR_HOSTNAME' directory
  echo $PRINT_LOG: Create Directory: $HOSTNAME to "$GCS_DIR_HOSTNAME" >> $LOG_PATH
  mkdir -p $GCS_DIR_HOSTNAME

  # Backup with mongodump shell
  /opt/mongodb/bin/mongodump --host $MONGO_HOST --port $MONGO_PORT --username $MONGO_USERNAME --password $MONGO_PASSWORD --db $MONGO_DATABASE --out $TEMP_PATH &&

  # Execute compress tar.gz format
  echo $PRINT_LOG: Execute global_mongo_db/ compress >> $LOG_PATH
  cd $TEMP_PATH && tar -czf global_mongo_db.gz global_mongo_db/ --remove-file
  echo $PRINT_LOG: Compress "done" >> $LOG_PATH

  # Move 'global_mongo_db.gz' to $GCS_DIR_HOSTNAME
  echo $PRINT_LOG: Moving global_mongo_db.gz file to $GCS_DIR_HOSTNAME >> $LOG_PATH
  mv $TEMP_PATH/global_mongo_db.gz $GCS_DIR_HOSTNAME
  echo $PRINT_LOG: Moving "done" >> $LOG_PATH
}

#########################################
## Main

echo $PRINT_LOG: MongoDB Backup Script Running... >> $LOG_PATH

check_gcs
backup_mongodb

echo $PRINT_LOG: MongoDB Backup Script End >> $LOG_PATH

mv $LOG_PATH $GCS_DIR_HOSTNAME