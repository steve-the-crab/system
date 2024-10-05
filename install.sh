#! /bin/sh

# # Check if working directory matches the script's directory
# source /home/a/scripts/utility_functions.sh
# check_script_dir


# echo 1

# exit

###################################################
# git

cd ~

nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
nix-channel --update

nix-shell -p git
# nix-env -iA nixpkgs.git

git clone https://github.com/steve-the-crab/system
cd system

###################################################
# disk

# install and run disko
# nix-env -iA nixpkgs.disko
nix-shell -p disko
# nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko nixos-config/disko.nix

# mount

sudo -i

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


###



# gen and copy configs
sudo nixos-generate-config --root /mnt
sudo cp ./nixos-config/*.nix /etc/nixos/
sudo cp -r ./nixos-config/nixpkgs ~/


###


nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
# nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz home-manager
nix-channel --update
nixos-install --root /mnt --cores 0
