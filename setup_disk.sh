#! /bin/sh

set -e
set -u
set -x
## configure this!
hostname="nixos"
password="abc123"
diskdev=/dev/vda
bootpart=/dev/vda1
rootpart=/dev/vda2
volume_group=vg
logical_volume=root
encrypted_physical_volume=enc-pv



wipefs -a $diskdev

sgdisk -o -g -n 1::+550M -t 1:ef00 -n 2:: -t 2:8300 $diskdev


cryptsetup luksFormat --type=luks2 $rootpart
cryptsetup open $rootpart encrypted_physical_volume


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
