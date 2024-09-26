{ config, pkgs, ... }:

{
  # Bootloader Configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable LUKS2 Encrypted Root
  boot.initrd.luks.devices = {
    cryptroot = {
      device = "/dev/disk/by-uuid/your-root-uuid";
    };
  };

  # File Systems
  fileSystems."/" = {
    device = "/dev/mapper/cryptroot";
    fsType = "btrfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/your-esp-uuid";
    fsType = "vfat";
  };

  # Encrypted Swap with Random Key
  swapDevices = [
    {
      device = "/dev/disk/by-uuid/your-swap-uuid";
      encrypted = {
        enable = true;
        options = [ "--cipher", "aes-xts-plain64", "--key-size", "512", "--hash", "sha256", "--key-file", "/dev/urandom" ];
      };
    }
  ];

  # Other configurations...

  system.stateVersion = "24.05";
}