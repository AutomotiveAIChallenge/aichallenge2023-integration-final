#!/bin/bash -e

source vehicle.env

MAP_PATH="/home/autoware/autoware/map/data"

ros2 launch autoware_launch autoware.launch.xml vehicle_model:=$VEHICLE_MODEL sensor_model:=$SENSOR_MODEL map_path:=$MAP_PATH
