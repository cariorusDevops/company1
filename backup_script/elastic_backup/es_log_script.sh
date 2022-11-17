#!/bin/bash

#########################################
## Variables

# utility
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M)
SPECIFY_TIME=$(date +%H%M)

# log
LOG_TIME="$DATE $TIME"
LOG_PATH="/home/elasticsearch/${DATE}_${SPECIFY_TIME}_script_backup.log"
PRINT_LOG="$LOG_TIME $HOSTNAME"

# temporary
TEMP_PATH=/home/elasticsearch

# gcloud storage
STORE_PATH=/mnt/project-prod-db-backup/elastic_logging
STORE_LOG_PATH=/mnt/project-prod-db-backup/elastic_logging/logs

# es_repository
ES_REPOSITORY=project_prod_backup

#########################################
## Function

check_gcs() {
  # Check '$STORE_PATH' exist
  if [ -e $STORE_PATH ] && [ -r $STORE_PATH ] && [ -w $STORE_PATH ];then
      echo $PRINT_LOG: $STORE_PATH check successful >> $LOG_PATH
  else
      echo $PRINT_LOG: Please check $STORE_PATH exist and directory permission >> $LOG_PATH
      exit 1
  fi
}

backup_es() {
  curl -X PUT "localhost:9200/_snapshot/$ES_REPOSITORY/${DATE}_${SPECIFY_TIME}?wait_for_completion=true" && 

  echo $PRINT_LOG: "************************ ES API Backup Results **********************" >> $LOG_PATH
  curl -X GET localhost:9200/_snapshot/$ES_REPOSITORY/"${DATE}_${SPECIFY_TIME}"?pretty >> $LOG_PATH
  echo $PRINT_LOG: "*********************************************************************" >> $LOG_PATH
}

#########################################
## Main

echo $PRINT_LOG: ElasticSearch_Logging Backup Script Running... >> $LOG_PATH

check_gcs
backup_es

echo $PRINT_LOG: ElasticSearch_Logging Backup Script End >> $LOG_PATH

mv $LOG_PATH $STORE_LOG_PATH