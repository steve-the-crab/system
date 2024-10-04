{ config, pkgs, ... }: 
 
{

  # LUKS device to open before mounting / [root]
  boot.initrd.luks.devices = {
    luksroot = {
      device = "/dev/disk/by-label/luks";
      allowDiscards = true;
      preLVM = true;
    };
  };

}