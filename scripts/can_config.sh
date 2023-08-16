#!/bin/bash -e

# Set CAN parameters
sudo ip link set can0 type can bitrate 500000
sudo ip link set can0 txqueuelen 500000
sudo ip link set can0 up

echo "CAN configuration done"
