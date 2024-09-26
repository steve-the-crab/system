#! /bin/sh

set -e
set -u
set -x

# configure this!
hostname="nixos"
password="abc123"
diskdev=/dev/vda
bootpart=/dev/vda1
rootpart=/dev/vda2

sgdisk -o -g -n 1::+550M -t 1:ef00 -n 2:: -t 2:8300 $diskdev

echo "$password" | cryptsetup luksFormat --type=luks2 $rootpart
echo "$password" | cryptsetup luksOpen $rootpart enc-pv

pvcreate /dev/mapper/enc-pv
vgcreate vg /dev/mapper/enc-pv
lvcreate -L 16G -n swap vg
lvcreate -l '100%FREE' -n root vg

mkfs.fat $bootpart
mkdir /mnt/boot
mount $bootpart /mnt/boot

mkswap -L swap /dev/vg/swap
swapon /dev/vg/swap

# mkfs.ext4 -L root /dev/vg/root
mkfs.btrfs -L root /dev/mapper/vg-root




# Create subvolumes
mount /dev/vg/root /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@nix
btrfs subvolume create /mnt/@persist
btrfs subvolume create /mnt/@log
# Optionally create a read-only snapshot of the blank root
btrfs subvolume snapshot -r /mnt/@ /mnt/@root-blank
# Mount subvolumes
umount /mnt
mount -o subvol=@ /dev/mapper/vg-root /mnt
mkdir -p /mnt/{home,nix,persist,log,boot}
mount -o subvol=@home /dev/mapper/vg-root /mnt/home
mount -o subvol=@nix /dev/mapper/vg-root /mnt/nix
mount -o subvol=@persist /dev/mapper/vg-root /mnt/persist
mount -o subvol=@log /dev/mapper/vg-root /mnt/log
 




nixos-generate-config --root /mnt

# nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
# nix-channel --add https://github.com/nix-community/home-manager/archive/release-21.11.tar.gz home-manager
# nix-channel --update



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
    };

    boot.cleanTmpDir = true;
    boot.kernelModules = [ "dm-snapshot" ];
    nixpkgs.config.allowUnfree = true;
    networking.hostName = "nixos";
    time.timeZone = "BST";
    environment.systemPackages = with pkgs; [
        curl
        firefox
        gcc
        git
        kate
        gparted
        btrfs-assistant
    ];
    # services.openssh.enable = true;
    # services.openssh.passwordAuthentication = false;

    # services.xserver.enable = true;
    # services.xserver.windowManager.i3.enable = true;
 
    # Enable X11
    services.xserver.enable = true;
    services.xserver.displayManager.sddm.enable = true; # SDDM is recommended for KDE Plasma
    services.xserver.desktopManager.plasma5.enable = true;

    # virtualisation.qemu.options = [
    #   "-vga qxl"
    #   "-spice port=5924,disable-ticketing=on"
    #   "-device virtio-serial -chardev spicevmc,id=vdagent,debug=0,name=vdagent"
    #   "-device virtserialport,chardev=vdagent,name=com.redhat.spice.0"
    # ];

  services.spice-vdagentd.enable = true;

  system.stateVersion = "24.05";
  }
EOF
