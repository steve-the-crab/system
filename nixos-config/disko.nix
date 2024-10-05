{
  disko.devices = {
    disk = {
      vda = {
        type = "disk";
        device = "/dev/vda";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              label = "boot";
              name = "ESP";
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                ];
              };
            };
            luks = {
              size = "100%";
              label = "luks";
              content = {
                type = "luks";
                name = "cryptroot";
                extraOpenArgs = [
                  "--allow-discards"
                  "--perf-no_read_workqueue"
                  "--perf-no_write_workqueue"
                ];
                # https://0pointer.net/blog/unlocking-luks2-volumes-with-tpm2-fido2-pkcs11-security-hardware-on-systemd-248.html
                settings = {crypttabExtraOpts = ["fido2-device=auto" "token-timeout=10"];};
                content = {
                  type = "btrfs";
                  extraArgs = ["-L" "nixos" "-f"];
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = ["subvol=root" "noatime"];
                    };
                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = ["subvol=home" "noatime"];
                    };
                    "/home/archive" = {
                      mountpoint = "/home/archive";
                      mountOptions = ["subvol=home/archive" "compress=zstd"];
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = ["subvol=nix" "noatime"];
                    };
                    "/swap" = {
                      mountpoint = "/swap";
                      swap.swapfile.size = "16G";
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  fileSystems."/".neededForBoot = true;
  # fileSystems."/archive".neededForBoot = true;
}













# {
#   disko.devices = {
#     disk = {
#       main = {
#         type = "disk";
#         device = "/dev/vda";
#         content = {
#           type = "gpt";
#           partitions = {
#             boot = {
#               size = "1M";
#               type = "EF02"; # for grub MBR
#             };
#             ESP = {
#               size = "512M";
#               type = "EF00";
#               content = {
#                 type = "filesystem";
#                 format = "vfat";
#                 mountpoint = "/boot";
#                 mountOptions = [ "umask=0077" ];
#               };
#             };
#             root = {
#               size = "100%";
#               content = {
#                 type = "filesystem";
#                 format = "ext4";
#                 mountpoint = "/";
#               };
#             };
#           };
#         };
#       };
#     };
#   };
# }


# {
#   disko.devices = {
#     disk {

#     }
#     disk = "/dev/vda";
#     partitions = [
#       {
#         label = "boot";
#         size = 550; # Size in MB
#         type = "ef00"; # EFI partition type
#         format = { fstype = "vfat"; label = "EFI"; options = [ "-F32" ]; };
#         mountPoint = "/boot";
#       }
#       {
#         label = "root";
#         type = "8300"; # Linux root partition type
#         luks = {
#           enable = true;
#           name = "cryptroot";
#           keyFile = null;
#         };
#         lvm = {
#           enable = true;
#           volumeGroup = "vg";
#           logicalVolumes = [
#             {
#               name = "root";
#               size = "100%FREE";
#               format = {
#                 fstype = "btrfs";
#                 label = "NixOS";
#                 options = [ "rw" "noatime" "compress=zstd" "discard=async" "space_cache=v2" "commit=120" ];
#               };
#               subvolumes = [
#                 { name = "@"; mountPoint = "/"; }
#                 { name = "@home"; mountPoint = "/home"; }
#                 { name = "@snapshots"; mountPoint = "/snapshots"; }
#                 { name = "@nix"; mountPoint = "/nix"; }
#                 { name = "@archive"; mountPoint = "/home/archive"; }
#               ];
#             }
#           ];
#         };
#       }
#     ];
#   };
# }