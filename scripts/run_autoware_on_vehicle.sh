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
  echo "  Error: Specified USB NIC has not connected."
  exit 1
fi

echo "USB NIC connection OK."
echo "VEHICLE_ID = $VEHICLE_ID"


### Lidar connection check
/bin/ping 192.168.1.201 -w 1 -c 1 >> /dev/null
if [ $? == 0 ]; then
  echo "Velodyne connection OK."
  exit 1
else
  echo "Error: Please check network settings and vehicle power is ON."
  exit 1
fi


### CAN interface connection check
# if can0 does not exist, configure can0
set -e
echo "Configuring CAN interface..."
sudo ip link set can0 type can bitrate 500000
sudo ip link set can0 txqueuelen 500000
sudo ip link set can0 up
set +e

# candump can0 check, get data ?
#   if no: error, please check vehicle power is ON, exit...
#   if yes: OK!

### set environment
export VEHICLE_MODEL=ymc_golfcart
export SENSOR_MODEL=aip_aichallenge
export MAP_PATH="/home/autoware/autoware/map/data"

# echo env var
echo "Launch autoware."
# wait 1 sec.

ros2 launch autoware_launch autoware.launch.xml vehicle_model:=$VEHICLE_MODEL sensor_model:=$SENSOR_MODEL map_path:=$MAP_PATH
