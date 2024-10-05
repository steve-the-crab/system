#! /bin/sh

# # Check if working directory matches the script's directory
# source /home/a/scripts/utility_functions.sh
# check_script_dir

# check if sudo
if [[ "$EUID" -ne 0 ]]; then
  echo "This script must be run as root."
  exit 1
fi


# setup git repo
cd ~
# nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
# nix-channel --update

nix-shell -p git --run "git clone https://github.com/steve-the-crab/system 2>/dev/null"
# nix-env -iA nixpkgs.git
cd system


# setup disk

# install and run disko
# nix-env -iA nixpkgs.disko
nix-shell -p disko --run "disko nixos-config/disko.nix"

# nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko nixos-config/disko.nix
  


# mount


# Mount the root subvolume
mount -o subvol=root,noatime /dev/mapper/cryptroot /mnt

# Mount the /boot partition
mkdir -p /mnt/boot
mount /dev/disk/by-partlabel/boot /mnt/boot

# Mount other subvolumes
mkdir -p /mnt/home /mnt/home/archive /mnt/nix /mnt/swap
mount -o subvol=home,noatime /dev/mapper/cryptroot /mnt/home
mount -o subvol=home/archive,compress=zstd /dev/mapper/cryptroot /mnt/home/archive
mount -o subvol=nix,noatime /dev/mapper/cryptroot /mnt/nix
mount -o subvol=swap,noatime /dev/mapper/cryptroot /mnt/swap


###

# exit

# gen and copy configs
nixos-generate-config --root /mnt
cp ./nixos-config/*.nix /etc/nixos/
cp -r ./nixos-config/nixpkgs ~/


###


nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
# nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz home-manager
nix-channel --update
nixos-install --root /mnt --cores 0
