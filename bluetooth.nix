{ config, pkgs, ... }:

{ 

  hardware = {
      bluetooth = {
        enable = true;
        pulseaudioSupport = true; # PipeWire will take care of this
        settings = {
          General = {
            Enable = "Source,Sink,Media,Socket";
          };
        };
      }; 
    };

    services = {
      blueman.enable = true;
      bluez.enable = true;
    };

}


