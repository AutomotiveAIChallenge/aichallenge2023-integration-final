#!/bin/bash

for DEV in `find /sys/devices -name net | grep -v virtual`
do
  DEV_NAME=("$(ls --quoting-style=shell $DEV)")
  if [ $DEV_NAME =~ "can0" ]; then
    CAN_IF_EXIST=true
  fi
done

### CAN interface connection check
# If can0 does not exist, configure can0
if [ -z $CAN_IF_EXIST ]; then
  set -e
  echo "Configuring CAN interface..."
  sudo ip link set can0 type can bitrate 500000
  sudo ip link set can0 txqueuelen 500000
  sudo ip link set can0 up
  set +e
fi

# candump can0 check, get data ?
if [ -z "`candump can0 -T 200`" ]; then
  echo "Error: Please check vehicle power is ON."
  exit 1
fi

echo "CAN Interface configuration done."
