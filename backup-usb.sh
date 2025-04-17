MOUNT_POINT=$1
SOURCE_PATH=$(realpath ${MOUNT_POINT})/DCIM
DEVICE_PATH=$2
DISK_LABEL=$3
uuid=`udevil info $DEVICE_PATH | grep '^  uuid:' | sed 's/^  uuid: *\(.*\)/\1/'`
if [ -d "$SOURCE_PATH" ]; then
  echo "$SOURCE_PATH does exist."
  uuid=`udevil info $DEVICE_PATH | grep '^  uuid:' | sed 's/^  uuid: *\(.*\)/\1/'`
  timestamp=`date +%Y-%m-%d.%H:%M:%S`
  DESTPATH="/data/usb/$uuid/$timestamp"
  echo "$DESTPATH"
  mkdir -p "$DESTPATH"
fi