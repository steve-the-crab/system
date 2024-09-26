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
      jack = {
        enable = true;
        # bufferSize = 128; # Low latency, adjust if needed
        # latency = "256/48000"; # Adjust based on your needs
      };
      wireplumber.enable = true; # Enable wireplumber
    };
  };

  environment.systemPackages = with pkgs; [
    alsa-utils
    alsa-plugins
    alsa-firmware
    pavucontrol
    helvum
    qpwgraph
  ];

   hardware.pulseaudio.package = pkgs.pipewire;
 
}