{ config, pkgs, ... }: 
 
{

  # LUKS device to open before mounting / [root]
  boot.initrd.luks.devices = {
    luksroot = {
      device = "/dev/disk/by-uuid/<root_partition>";
      allowDiscards = true;
      preLVM = true;
    };
  };

}