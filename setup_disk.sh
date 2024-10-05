#! /bin/sh

set -e
set -u
set -x
## configure this!
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

### btrfs

export BTRFS_OPT=rw,noatime,discard=async,space_cache=v2,commit=120
export BTRFS_COMPRESSED_OPT=rw,noatime,compress-force=zstd,discard=async,space_cache=v2,commit=120

# Initial mount of the filesystem
mount -o $BTRFS_OPT /dev/mapper/$volume_group-$logical_volume /mnt

# Creating subvolumes
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/home/@archive
btrfs subvolume create /mnt/@snapshots
btrfs subvolume create /mnt/@nix

# Unmounting the filesystem
umount /mnt

# Mounting the root subvolume
mount -o $BTRFS_OPT,subvol=@ /dev/mapper/$volume_group-$logical_volume /mnt

# Creating necessary directories
mkdir /mnt/home
mkdir /mnt/home/archive
mkdir /mnt/nix
mkdir /mnt/snapshots  # Create directory for snapshots

# Mounting subvolumes
mount -o $BTRFS_OPT,subvol=@home /dev/mapper/$volume_group-$logical_volume /mnt/home/
mount -o $BTRFS_COMPRESSED_OPT,subvol=@home/@archive /dev/mapper/$volume_group-$logical_volume /mnt/home/archive/
mount -o $BTRFS_OPT,subvol=@nix /dev/mapper/$volume_group-$logical_volume /mnt/nix/
mount -o $BTRFS_OPT,subvol=@snapshots /dev/mapper/$volume_group-$logical_volume /mnt/snapshots/

# snapshots
btrfs subvolume snapshot /mnt/@home /mnt/@home-blank
btrfs subvolume snapshot /mnt/@home/@archive /mnt/@archive-blank

### boot

mkdir -p /mnt/boot/
mount -o rw,noatime $bootpart /mnt/boot/
