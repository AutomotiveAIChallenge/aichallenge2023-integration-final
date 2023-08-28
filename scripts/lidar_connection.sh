#!/bin/bash

### USB NIC connection check and get VEHICLE_ID
declare -A NIC_DEV=(    #Specified USB NIC ID
    ["enxc436c0eaa070"]="GCP02"
    ["enx00e04c0a0ba6"]="GCP03"
)

for DEV in `find /sys/devices -name net | grep -v virtual`
do
  DEV_NAME=("$(ls --quoting-style=shell $DEV)")
  if [ -n "${NIC_DEV[$DEV_NAME]}" ]; then
    export VEHICLE_ID="${NIC_DEV[$DEV_NAME]}"   # Export VEHICLE_ID
  fi
done

if [ -z $VEHICLE_ID ]; then
  echo "Error: Specified USB NIC is not connected."
  exit 1
fi

echo "USB NIC connectivity OK."
echo "VEHICLE_ID=$VEHICLE_ID"

### Lidar connection check
/bin/ping 192.168.1.201 -w 1 -c 1 >> /dev/null
if [ $? == 0 ]; then
  echo "Velodyne connectivity OK."
else
  echo "Error: Please check network settings and vehicle power is ON."
  exit 1
fi
