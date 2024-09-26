#! /bin/sh

set -e
set -u
set -x
## configure this!
# hostname="nixos"
password="abc123"
# diskdev=/dev/vda
# bootpart=/dev/vda1
# rootpart=/dev/vda2
# volume_group=vg
# logical_volume=root
# encrypted_physical_volume=enc-pv

device="/dev/vda"
device1="/dev/vda1"
device2="/dev/vda2"



wipefs -a $diskdev

sgdisk -o -g -n 1::+550M -t 1:ef00 -n 2:: -t 2:8300 $device


cryptsetup luksFormat --type=luks2 $device2
cryptsetup open $device2 nixenc


pvcreate /dev/mapper/nixenc
vgcreate vg /dev/mapper/nixenc

lvcreate -n swap -L 16GB vg       # the swap partition
lvcreate -n root -l +100%FREE vg # root partition with the os and everything else


mkfs.vfat -n boot $device1

mkswap /dev/mapper/vg-swap
swapon /dev/mapper/vg-swap



mkfs.btrfs -L root /dev/mapper/vg-root

# If you want to set up brtfs subvolumes, now is a good time for that.

mount /dev/mapper/vg-root /mnt

mkdir /mnt/boot
mount $device1 /mnt/boot






nixos-generate-config --root /mnt




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

sed -i "s|<your-encrypted-partition-uuid>|$luksuuid|g" /mnt/etc/configuration.nix


 


# Usually, it’s a good idea to take a look at the auto generated hardware-configuration.nix and add it to the already existing config because it has all disks and everything else detected by nixos-generate-config.
# nixos-unstable

nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable

nix-channel --update

nixos-install --root /mnt --cores 0















vgcreate $volume_group /dev/mapper/encrypted_physical_volume
lvcreate --name $logical_volume -l +100%FREE $volume_group


mkfs.vfat -n EFI -F 32 $bootpart
mkfs.btrfs -L NixOS /dev/mapper/$volume_group-$logical_volume


# export BTRFS_OPT=rw,noatime,discard=async,compress-force=zstd,space_cache=v2,commit=120
export BTRFS_OPT=rw,noatime,discard=async,space_cache=v2,commit=120
mount -o $BTRFS_OPT /dev/mapper/$volume_group-$logical_volume /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots
btrfs subvolume create /mnt/@nix
btrfs subvolume create /mnt/@nixos-config
btrfs subvolume create /mnt/@log
umount /mnt
mount -o $BTRFS_OPT,subvol=@ /dev/mapper/$volume_group-$logical_volume /mnt
mkdir /mnt/home
mkdir /mnt/nix
mkdir -p /mnt/etc/nixos
mkdir -p /mnt/var/log
mount -o $BTRFS_OPT,subvol=@home /dev/mapper/$volume_group-$logical_volume /mnt/home/
mount -o $BTRFS_OPT,subvol=@nix /dev/mapper/$volume_group-$logical_volume /mnt/nix/
mount -o $BTRFS_OPT,subvol=@nixos-config /dev/mapper/$volume_group-$logical_volume /mnt/etc/nixos/
mount -o $BTRFS_OPT,subvol=@log /dev/mapper/$volume_group-$logical_volume /mnt/var/log
mkdir -p /mnt/boot/
mount -o rw,noatime $bootpart /mnt/boot/

 
nixos-generate-config --root /mnt


nixos-generate-config --root /mnt
nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
nix-channel --add https://github.com/nix-community/home-manager/archive/release-21.11.tar.gz home-manager
nix-channel --update
nixos-install --root /mnt --cores 0