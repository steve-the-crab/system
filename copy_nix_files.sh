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



luksuuid="unset"
for uuid in /dev/disk/by-uuid/*
do
	if test $(readlink -f $uuid) = $rootpart
	then
		luksuuid=$uuid
		break
	fi
done
if [ "$luksuuid" = "unset" ]; then
  echo "luksuuid is unset. Exiting..."
  exit 1
fi

echo $luksuuid

exit

sed -i "s|/dev/disk/by-uuid/<root_partition>|$luksuuid|g" /mnt/etc/nixos/luks.nix

