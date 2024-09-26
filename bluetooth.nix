{ config, pkgs, ... }:

{ 

  hardware = {
      bluetooth = {
        enable = true;
        settings = {
          General = {
            Enable = "Source,Sink,Media,Socket";
          };
        };
      }; 
    };

    services = {
      blueman.enable = true;
      bluez.enable = true; # Add this to ensure bluez service is enabled
    };

}



services.bluez = {
  enable = true;
};

hardware.bluetooth = {
  enable = true;
  pulseaudioSupport = true; # PipeWire will take care of this
};