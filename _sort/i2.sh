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
volume_group=vg
logical_volume=root
encrypted_physical_volume=enc-pv


# wipe
umount -f enc-pv || true
umount -f $rootpart || true
umount -f $bootpart || true
umount -f $diskdev || true
cryptsetup luksClose enc-pv || true
echo "YES" | cryptsetup luksErase $rootpart || true
vgchange -an vg || true
echo 1 > /sys/block/$bootpart/device/delete || true
echo 1 > /sys/block/$rootpart/device/delete || true
echo 1 > /sys/block/$diskdev/device/delete || true
wipefs -a $diskdev || true

###

sgdisk -o -g -n 1::+550M -t 1:ef00 -n 2:: -t 2:8300 $diskdev

echo "$password" | cryptsetup luksFormat --type=luks2 $rootpart
echo "$password" | cryptsetup luksOpen $rootpart enc-pv

pvcreate /dev/mapper/enc-pv
vgcreate vg /dev/mapper/enc-pv
lvcreate -L 16G -n swap vg 
lvcreate -l '100%FREE' -n root vg

###

mkfs.vfat -n EFI -F 32 $bootpart
mkfs.btrfs -L NixOS /dev/mapper/vg-root

export BTRFS_OPT=rw,noatime,discard=async,compress-force=zstd,space_cache=v2,commit=120
mount -o $BTRFS_OPT /dev/mapper/vg-root /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots
btrfs subvolume create /mnt/@nix
btrfs subvolume create /mnt/@nixos-config
btrfs subvolume create /mnt/@log
umount /mnt
mount -o $BTRFS_OPT,subvol=@ /dev/mapper/vg-root /mnt
mkdir /mnt/home
mkdir /mnt/nix
mkdir -p /mnt/etc/nixos
mkdir -p /mnt/var/log
mount -o $BTRFS_OPT,subvol=@home /dev/mapper/vg-root /mnt/home/
mount -o $BTRFS_OPT,subvol=@nix /dev/mapper/vg-root /mnt/nix/
mount -o $BTRFS_OPT,subvol=@nixos-config /dev/mapper/vg-root /mnt/etc/nixos/
mount -o $BTRFS_OPT,subvol=@log /dev/mapper/vg-root /mnt/var/log
mkdir -p /mnt/boot/
mount -o rw,noatime $bootpart /mnt/boot/

mkswap -L swap /dev/vg/swap
swapon /dev/vg/swap

###

nixos-generate-config --root /mnt
nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
nix-channel --add https://github.com/nix-community/home-manager/archive/release-21.11.tar.gz home-manager
nix-channel --update
nixos-install --root /mnt --cores 0

###


for uuid in /dev/disk/by-uuid/*
do
	if test $(readlink -f $uuid) = $rootpart
	then
		luksuuid=$uuid
		break
	fi
done

cat <<-"EOF" > /mnt/etc/nixos/configuration.nix
  { config, pkgs, ... }:

  {
    imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

    fileSystems."/" =
      { options = [ "rw" "noatime" "discard=async" "compress-force=zstd" "space_cache=v2" "commit=120" ];
    };
    fileSystems."/home" =
      { options = [ "rw" "noatime" "discard=async" "compress-force=zstd" "space_cache=v2" "commit=120" ];
    };
    fileSystems."/nix" =
      { options = [ "rw" "noatime" "discard=async" "compress-force=zstd" "space_cache=v2" "commit=120" ];
    };
    fileSystems."/etc/nixos" =
      { options = [ "rw" "noatime" "discard=async" "compress-force=zstd" "space_cache=v2" "commit=120" ];
    };
    fileSystems."/var/log" =
      { options = [ "rw" "noatime" "discard=async" "compress-force=zstd" "space_cache=v2" "commit=120" ];
    };



  # # LUKS device to open before mounting / [root]
  # boot.initrd.luks.devices = {
  #   luksroot = {
  #     device = "$luksuuid";
  #     device = "/dev/disk/by-uuid/<root_partition>";
  #     allowDiscards = true;
  #     preLVM = true;
  #   };
  # };




    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.supportedFilesystems = [ "btrfs" ];
    hardware.enableAllFirmware = true;
    nixpkgs.config.allowUnfree = true;
  



    boot.initrd.luks.devices = {
      "enc-pv" = {
        device = "$luksuuid";
        preLVM = true;
        allowDiscards = true;
      };
    };





  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;



    # boot.loader.systemd-boot.enable = true;
    # boot.loader.efi.canTouchEfiVariables = true;
    # boot.initrd.kernelModules = [ "dm-snapshot" ];

    # boot.initrd.luks.devices = {
    #   "enc-pv" = {
    #     device = "$luksuuid";
    #     preLVM = true;
    #     allowDiscards = true;
    #   };
    # };

    boot.cleanTmpDir = true;
    boot.kernelModules = [ "dm-snapshot" ];
    nixpkgs.config.allowUnfree = true;
    networking.hostName = "nixos";
    networking.networkmanager.enable = true;
    time.timeZone = "BST";
    i18n.defaultLocale = "en_GB.UTF-8";
    # console = {
    #   #   font = "Lat2-Terminus16";
    #     keyMap = "uk";
    #   #   useXkbConfig = true; # use xkbOptions in tty.
    # };
    services.xserver.layout = "uk";

    # Enable touchpad support (enabled default in most desktopManager).
    services.xserver.libinput.enable = true;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.leot = {
      isNormalUser = true;
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
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


    # services.openssh.enable = true;
    # services.openssh.passwordAuthentication = false;

    # services.xserver.enable = true;
    # services.xserver.windowManager.i3.enable = true;
 
    # Enable X11
    services.xserver.enable = true;
    services.xserver.displayManager.sddm.enable = true; # SDDM is recommended for KDE Plasma
    services.xserver.desktopManager.plasma5.enable = true;



  services.spice-vdagentd.enable = true;

  system.stateVersion = "24.05";
  }
EOF
