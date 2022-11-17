#!/bin/bash

#########################################
## Variables

# utility
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M)

# es
YEAR=$(date +%Y)
MONTH=$(date +%m)
DAY=$(date +%d)
WEEK_NUMBER_OF_MONTH=$(( (10#$(date +%d)) / 7 ))
WEEK_NUMBER_OF_YEAR=$(date +%U)

# log
LOG_TIME="$DATE $TIME"
LOG_PATH="/home/elasticsearch/delete_eslog_script_log/${DATE}.log"
PRINT_LOG="$LOG_TIME $HOSTNAME"

#########################################
## Function

delete_es_log() {
  START=$1
  END=$2

  echo PRINT_LOG: "WEEK_NUMBER_OF_MONTH: $WEEK_NUMBER_OF_MONTH, START: $START, END: $END" >> $LOG_PATH

  for EL in $(seq -f "%02g" $START $END); do
    # write in log
    echo $PRINT_LOG: "localhost:9200/*-*-*-$YEAR.$MONTH.$EL" >> $LOG_PATH
    echo $PRINT_LOG: "localhost:9200/*-*-*-*-$YEAR.$MONTH.$EL" >> $LOG_PATH
    echo $PRINT_LOG: "localhost:9200/*-*-*-*-*-$YEAR.$MONTH.$EL" >> $LOG_PATH

    # run command
    curl -X DELETE "localhost:9200/*-*-*-$YEAR.$MONTH.$EL"
    curl -X DELETE "localhost:9200/*-*-*-*-$YEAR.$MONTH.$EL"
    curl -X DELETE "localhost:9200/*-*-*-*-*-$YEAR.$MONTH.$EL"
  done
}

#########################################
## Main

case "$WEEK_NUMBER_OF_MONTH" in
    1)  
        MONTH=0$(( (10#$(date +%m)) -1 ))
        delete_es_log 25 31;;          
    2)
        delete_es_log 01 08;;
    3)
        delete_es_log 09 16;;
    4)
        delete_es_log 17 24
esac