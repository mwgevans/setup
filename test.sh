#!/bin/bash

process_file(){
    # Do stuff
  while read -r data; do
      ITEM=$(realpath ${DESTPATH})/$data
      ITEMDEST=/data/usb/$uuid/ALL/$data
      ITEM_DEST_DIR=$(dirname ${ITEMDEST})
      mkdir -p $ITEM_DEST_DIR
      echo $ITEM
      echo $ITEMDEST
      ln $ITEM $ITEMDEST
  done
}

LOG_FILE=$1
echo "$LOG_FILE"
DESTPATH=$(dirname ${LOG_FILE})
uuid='654B-1891'
cat "$LOG_FILE" | awk '/>f/ {print $5}' | process_file
#cat "$LOG_awk '/>f/ {print}' < "$LOG_FILE" | process_file

./test.sh "/data/usb/654B-1891/2025-04-17.13:02:44/rsync_log.txt"