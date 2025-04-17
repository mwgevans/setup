MOUNT_POINT=$1
SOURCE_PATH=$(realpath ${MOUNT_POINT})/DCIM
DEVICE_PATH=$2
DISK_LABEL=$3
process_file(){
    # Do stuff
  while read -r data; do
      ITEM=$(realpath ${DESTPATH})/$data
      ITEMDEST=/data/usb/$uuid/ALL/$data
      ITEM_DEST_DIR=$(dirname ${ITEMDEST})
      mkdir -p $ITEM_DEST_DIR
      ln $ITEM $ITEM_DEST_DIR
  done
}
if [ -d "$SOURCE_PATH" ]; then
  echo "$SOURCE_PATH does exist."
  uuid=`udevil info $DEVICE_PATH | grep '^  uuid:' | sed 's/^  uuid: *\(.*\)/\1/'`
  timestamp=`date +%Y-%m-%d.%H:%M:%S`
  DESTPATH="/data/usb/$uuid/$timestamp"
  ALLPATH="/data/usb/$uuid/ALL"
  echo "$DESTPATH"
  mkdir -p "$DESTPATH"
  mkdir -p "$ALLPATH"
  rsync -aru --include='*/' --include='*.JPG' --include='*.ARW' --exclude='*' --remove-source-files --info=progress2 --compare-dest="$ALLPATH" --log-file="$DESTPATH/rsync_log.txt" "$SOURCE_PATH" "$DESTPATH" 
  find "$SOURCE_PATH" -type d -empty -delete
  cat "$DESTPATH/rsync_log.txt" | awk '/>f/ {print $5}' | process_file

fi