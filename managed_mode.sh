#!/bin/bash

# Script to set $interface to managed mode and confirm success

source /home/jamier/scripts/.env

# Check that running as root
if [ "$EUID" -ne 0 ]
  then echo "Error: Please run as root"
  exit 1
fi

# Check if arguments have been provided
if [ $# -eq 0 ]; then
    interface=$INTERFACE
else
    if [ $# -eq 1 ]; then
        interface=$1
    else
        echo "Error: Incorrect arguments provided"
        exit 1
    fi
fi

# Check interface exists


# Take down interface
ifconfig $interface down > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Error: Failed to take $interface down, are you sure this interface exists?"
    exit 1
fi

# Set interface to monitor mode
iwconfig $interface mode managed 
if [ $? -ne 0 ]; then
    echo "Error: Failed set $interface to managed mode"
    exit 1
fi

# Bring interface back up
ifconfig $interface up
if [ $? -ne 0 ]; then
    echo "Error: Failed to bring $interface back up"
    exit 1
fi

# Check interface is running in monitor mode


echo "Success: $interface running in managed mode"
exit 0