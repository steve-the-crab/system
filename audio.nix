{ config, pkgs, ... }:

{ 
  
  sound = {
    enable = false;
    #mediaKeys.enable = true;
  };
  
  hardware = {
    pulseaudio.enable = false;
  };
  
  services = {
    pipewire = { 
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    alsa-utils
    alsa-plugins
    pavucontrol
    pipewire-jack
  ];

   hardware.pulseaudio.package = pkgs.pipewire;

  
}