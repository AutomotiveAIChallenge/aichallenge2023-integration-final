#!/bin/bash -e

echo "Checking USB NIC connection..."

# GCP02 NIC ID: enxc436c0eaa070
# GCP03 NIC ID: enx00e04c0a0ba6

# get vehicle id from NIC device id
declare -A NIC_DEV=(
    ["enxc436c0eaa070"]="GCP02"
    ["enx00e04c0a0ba6"]="GCP03"
)

for DEV in `find /sys/devices -name net | grep -v virtual`
do
  DEV_NAME=("$(ls --quoting-style=shell $DEV)")
  if [ -n "${NIC_DEV[$DEV_NAME]}" ]; then
    export VEHICLE_ID="${NIC_DEV[$DEV_NAME]}"
  fi
done

if [ -z $VEHICLE_ID ]; then
  echo "  Error: Specified USB NIC has not connected."
  exit 1
fi

echo "  VEHICLE_ID = $VEHICLE_ID"
echo "  Check OK."
