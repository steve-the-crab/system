{
  config, lib, pkgs, ... }:

let
  # Disk configuration
  diskConfig = {
    disk = "/dev/vda";
    partitions = [
      {
        label = "boot";
        size = 550; # Size in MB
        type = "ef00"; # EFI partition type
        format = { fstype = "vfat"; label = "EFI"; options = [ "-F32" ]; };
        mountPoint = "/boot";
      }
      {
        label = "root";
        type = "8300"; # Linux root partition type
        luks = {
          enable = true;
          name = "cryptroot";
          keyFile = null;
        };
        lvm = {
          enable = true;
          volumeGroup = "vg";
          logicalVolumes = [
            {
              name = "root";
              size = "100%FREE";
              format = {
                fstype = "btrfs";
                label = "NixOS";
                options = [ "rw" "noatime" "compress=zstd" "discard=async" "space_cache=v2" "commit=120" ];
              };
              subvolumes = [
                { name = "@"; mountPoint = "/"; };
                { name = "@home"; mountPoint = "/home"; };
                { name = "@snapshots"; mountPoint = "/snapshots"; };
                { name = "@nix"; mountPoint = "/nix"; };
                { name = "@archive"; mountPoint = "/home/archive"; };
              ];
            }
          ];
        };
      }
    ];
  };
in
{
  imports = [ diskoModule ];

  disko.configuration = {
    configVersion = "1";
    disks = {
      vda = diskConfig;
    };
  };

  # Additional NixOS configuration...
}