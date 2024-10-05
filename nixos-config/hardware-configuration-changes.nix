# Changes related to hardware-configuration.nix

{ config, pkgs, lib, ... }:

{ 
 
  fileSystems."/" =
      { options = [ "rw" "noatime" "discard=async" "space_cache=v2" "commit=120" ];
      };

    fileSystems."/home" =
      { options = [ "rw" "noatime" "discard=async" "space_cache=v2" "commit=120" ];
      };

    fileSystems."/archive" =
      { options = [ "rw" "compress-force=zstd" "discard=async" "space_cache=v2" "commit=120" ];
      };

    fileSystems."/nix" =
      { options = [ "rw" "noatime" "discard=async" "space_cache=v2" "commit=120" ];
      };

}
