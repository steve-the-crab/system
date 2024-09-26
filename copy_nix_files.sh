#! /bin/sh

device=$1

sudo cp *.nix /etc/nixos/

# Get the UUID of the root partition directly using blkid
luksuuid=$(blkid -s UUID -o value $device)

# Check if the UUID was successfully retrieved
if [ -z "$luksuuid" ]; then
    echo "luksuuid is unset. Exiting..."
    exit 1
fi

echo $luksuuid

sudo sed -i "s|/dev/disk/by-uuid/<root_partition>|/dev/disk/by-uuid/$luksuuid|g" /etc/nixos/luks.nix

