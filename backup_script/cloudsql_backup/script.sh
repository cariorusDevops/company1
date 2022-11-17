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

# gcloud storage
STORE_PATH="/mnt/project01-prod-db-backup/mysql"

# cloud sql for mysql
CLOUD_SQL_DATE=$(date -d'1days ago' +%Y-%m-%d)

CLOUD_BUCKET_NAME=project01-prod-db-backup

CLOUD_SQL_DIR=gcloud_export

CLOUD_SQL_INSTANCE=prod-project01-mysql-replica-01
CLOUD_SQL_DATABASE=global_3rd_db

CLOUD_SQL_BACKUP_NAME="project01-prod-sql_$SPECIFY_TIME"

# mix
GCS_STRUCTURE="$CLOUD_SQL_DIR/$DATE"
GCS_SQL_DIR="$GCS_STRUCTURE/$SPECIFY_TIME"

#########################################
## Function

check_gcs() {
  # Check '$STORE_PATH' exist
  if [ -e $STORE_PATH ] && [ -r $STORE_PATH ] && [ -w $STORE_PATH ];then

      if [ ! -e $STORE_PATH/$GCS_SQL_DIR ]; then
        # Create '$STORE_PATH' directory
        echo $PRINT_LOG: Create directory: $GCS_SQL_DIR to $STORE_PATH >> $LOG_PATH
        mkdir -p $STORE_PATH/$GCS_SQL_DIR

      else
          echo $PRINT_LOG: $STORE_PATH/$GCS_SQL_DIR Already exist >> $LOG_PATH
          exit 1
      fi

  else
      echo $PRINT_LOG: Please check $STORE_PATH exist and directory permission >> $LOG_PATH
      exit 1
  fi
}

backup_cloud_sql() {
  gcloud sql export sql $CLOUD_SQL_INSTANCE gs://$CLOUD_BUCKET_NAME/mysql/$GCS_SQL_DIR/$CLOUD_SQL_BACKUP_NAME.gz \
  --database=$CLOUD_SQL_DATABASE \
  --offload

  echo $PRINT_LOG: "************************ Day+1 / 時間需自行換算+8 **********************" >> $LOG_PATH
  gcloud sql operations list --instance=$CLOUD_SQL_INSTANCE --project=project01 | grep "$CLOUD_SQL_DATE" >> $LOG_PATH
  echo $PRINT_LOG: "***************************************************************" >> $LOG_PATH
}

#########################################
## Main

echo $PRINT_LOG: Cloud SQL Backup Script Running... >> $LOG_PATH

check_gcs
backup_cloud_sql

echo $PRINT_LOG: Cloud SQL Backup Script End >> $LOG_PATH

mv $LOG_PATH $STORE_PATH/$GCS_SQL_DIR