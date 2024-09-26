#!/usr/bin/env bash

DISK="vda"
DISK_1="vda1"
DISK_2="vda2"
DISK_3="vda3"

### partition
sudo parted -s /dev/$DISK -- mklabel gpt

sudo parted -s /dev/$DISK -- mkpart ESP fat32 1MiB 512MiB
sudo parted -s /dev/$DISK -- set 1 esp on

sudo parted -s /dev/$DISK -- mkpart primary 512MiB -16GiB

sudo parted -s /dev/$DISK -- mkpart primary linux-swap -16GiB 100%

### format
sudo mkfs.fat -F32 -I /dev/$DISK_1

sudo cryptsetup luksFormat --type luks2 /dev/$DISK_2
# echo -n "your_passphrase" | sudo cryptsetup luksFormat --type luks2 --batch-mode /dev/$DISK_2
sudo cryptsetup open /dev/$DISK_2 cryptroot

sudo mkfs.btrfs -f /dev/mapper/cryptroot

# sudo mount /dev/mapper/cryptroot /mnt

# sudo mkdir /mnt/boot
# sudo mount /dev/$DISK_1 /mnt/boot

# ### nixos config
# nixos-generate-config --root /mnt

