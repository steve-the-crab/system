#!/usr/bin/env bash

DISK="vda"
DISK_1="vda1"
DISK_2="vda2"
DISK_3="vda3"


# Function to replace the UUID of a device in a specified file
replace_uuid() {
    local target_file=$1
    local device=$2
    local find_str=$3

    # Extract the UUID for the given device
    uuid=$(blkid -s UUID -o value "$device")

    # Check if the UUID was found
    if [ -n "$uuid" ]; then
        echo "UUID for $device: $uuid"

        # Run sed to replace the UUID in the target file
        sed -i "s/$uuid/my-replaced-string/g" "$target_file"
        echo "Replaced UUID in $target_file"
    else
        echo "No UUID found for $device"
    fi
}

##############################
##############################
##############################

# curl https://investravel.com/t/part.sh -o part.sh
# chmod +x part.sh
# ./part.sh -i

##############################
##############################
##############################

curl https://investravel.com/t/configuration.nix -o configuration.nix

target_file="configuration.nix"
replace_uuid $target_file "/dev/$DISK_1" "your-esp-uuid" 
replace_uuid $target_file "/dev/$DISK_2" "your-root-uuid" 
replace_uuid $target_file "/dev/$DISK_3" "your-swap-uuid" 

##############################
##############################
##############################

echo "here";


