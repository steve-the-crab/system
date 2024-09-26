#! /bin/sh

set -e
set -u
set -x

# configure
hostname="nixos"
password="abc123"
diskdev=/dev/vda
bootpart=/dev/vda1
rootpart=/dev/vda2

sgdisk -o -g -n 1::+550M -t 1:ef00 -n 2:: -t 2:8300 $diskdev

echo "$password" | cryptsetup luksFormat $rootpart
echo "$password" | cryptsetup luksOpen $rootpart enc-pv

pvcreate /dev/mapper/enc-pv
vgcreate vg /dev/mapper/enc-pv
lvcreate -L 16G -n swap vg
lvcreate -l '100%FREE' -n root vg

# mkfs.fat $bootpart
mkfs.vfat -n EFI -F 32 $bootpart
mkfs.ext4 -L root /dev/vg/root
mkswap -L swap /dev/vg/swap

swapon /dev/vg/swap
mount /dev/vg/root /mnt
mkdir /mnt/boot
mount $bootpart /mnt/boot


nixos-generate-config --root /mnt
nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
nix-channel --add https://github.com/nix-community/home-manager/archive/release-21.11.tar.gz home-manager
nix-channel --update
nixos-install --root /mnt --cores 0

for uuid in /dev/disk/by-uuid/*
do
	if test $(readlink -f $uuid) = $rootpart
	then
		luksuuid=$uuid
		break
	fi
done

cat << EOF > /mnt/etc/nixos/configuration.nix
  { config, pkgs, ... }:

   {
        imports =
        [ # Include the results of the hardware scan.
          ./hardware-configuration.nix
        ];
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        boot.initrd.kernelModules = [ "dm-snapshot" ];
        boot.initrd.luks.devices = {
        "enc-pv" = {
            device = "$luksuuid";
            preLVM = true;
            allowDiscards = true;
        };
        boot.cleanTmpDir = true;
        boot.kernelModules = [ "dm-snapshot" ];
        nixpkgs.config.allowUnfree = true;
        networking.hostName = "nixos";
        time.timeZone = "BST";
        i18n.defaultLocale = "en_GB.UTF-8";
        # console = {
        #   #   font = "Lat2-Terminus16";
        #     keyMap = "uk";
        #   #   useXkbConfig = true; # use xkbOptions in tty.
        # };


        # X11
        services.xserver.enable = true;
        services.xserver.displayManager.sddm.enable = true; # SDDM is recommended for KDE Plasma
        services.xserver.desktopManager.plasma5.enable = true;
        services.xserver.layout = "uk";
        services.xserver.libinput.enable = true;


        # Define a user account. Don't forget to set a password with "passwd".
        users.users.a = {
            isNormalUser = true;
            extraGroups = [ "wheel" ]; # Enable "sudo" for the user.
            hashedPassword = "RUN `mkpasswd -m sha-512` TO GENERATE IT";
            #   packages = with pkgs; [
            #     firefox
            #     tree
            #   ];
        };


        environment.systemPackages = with pkgs; [
            curl
            firefox
            gcc
            git
            kate
            gparted
            btrfs-assistant
        ];

        # environment.variables.EDITOR = "nano";

        services.spice-vdagentd.enable = true;

        system.stateVersion = "24.05"; # Did you read the comment?
    }
EOF