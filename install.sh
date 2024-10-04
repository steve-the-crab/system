#! /bin/sh

# Check if working directory matches the script's directory
source /home/a/scripts/utility_functions.sh
check_script_dir


echo 1

exit

###

# install and run disko
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko nixos-config/disko.nix


# Mount the root subvolume
mount -o subvol=root,noatime /dev/mapper/cryptroot /mnt

# Mount the /boot partition
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

# Mount other subvolumes
mkdir -p /mnt/home /mnt/home/archive /mnt/nix /mnt/swap
mount -o subvol=home,noatime /dev/mapper/cryptroot /mnt/home
mount -o subvol=home/archive,compress=zstd /dev/mapper/cryptroot /mnt/home/archive
mount -o subvol=nix,noatime /dev/mapper/cryptroot /mnt/nix
mount -o subvol=swap,noatime /dev/mapper/cryptroot /mnt/swap