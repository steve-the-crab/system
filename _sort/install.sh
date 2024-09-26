#!/usr/bin/env bash

###################################################

# config
DEVICE="vda"

read -s -p "Enter passphrase for encrypted devices: " PASSPHRASE
echo

 
###################################################

# functions
disk_setup() {
    # local target_file=$1

    # Create the partition table and partitions
    parted --script /dev/"${DEVICE}" \
        mklabel gpt \
        mkpart primary fat32 1MiB 501MiB \
        set 1 esp on \
        mkpart primary 501MiB 100%


    # cryptsetup
    echo $PASSPHRASE | cryptsetup luksFormat --type luks2 /dev/"${DEVICE}2"
    echo $PASSPHRASE | cryptsetup open /dev/"${DEVICE}2" nixenc

    # # volumes
    # pvcreate /dev/mapper/nixenc
    # vgcreate vg /dev/mapper/nixenc
    # lvcreate -n swap -L 16GB vg       # the swap partition
    # lvcreate -n root -l +100%FREE vg # root partition with the os and everything else


    # # create the efi partition:
    # mkfs.vfat -n boot /dev/"${DEVICE}1"

    # # create and enable the swap partition:
    # mkswap /dev/mapper/vg-swap
    # swapon /dev/mapper/vg-swap

    # # create the btrfs root partition:
    # mkfs.btrfs -L root /dev/mapper/vg-root
}

nix_setup() {
    # Mount the new btrfs partition to /mnt:
    mount /dev/mapper/vg-root /mnt

    # And mount the uefi partition to /mnt/boot:
    mkdir /mnt/boot
    mount /dev/"${DEVICE}1" /mnt/boot

    # generate a new nixos config
    nixos-generate-config --root /mnt

    # configure the nixos config
    # Note that you need to clone the repo to /mnt because that’s where we the root os partition is mounted:
    # mkdir /mnt/var
    # cd /mnt/var
    # git clone <path to the repo>

    # # To create the symlink, it’s important to create one with a relative path - nixos is not yet installed in / but in /mnt. I usually do something like this:
    # cd /mnt/etc/nixos
    # mv configuration.nix configuration.generated.nix
    # ln -s ../../var/nix/configuration.nix configuration.nix

}


###################################################

# wipe
# umount /mnt
# umount /mnt/boot
# umount /dev/vda1
# umount /dev/vda2
# umount /dev/nixenc
# swapoff /dev/mapper/vg-swap
# sudo cryptsetup luksClose /dev/"${DEVICE}2"
# sudo cryptsetup luksClose nixenc
# sgdisk --zap-all /dev/vda
# dd if=/dev/zero of=/dev/"${DEVICE}" bs=512 count=1
# partprobe /dev/vda

# install

disk_setup
# nix_setup

