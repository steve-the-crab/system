{ config, pkgs, ... }:

{
  # Import the Home Manager module
  imports = [
    <home-manager/nixos>
  ];

  # Enable Home Manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  # Optional: user configuration for Home Manager
  users.users.a = {
    isNormalUser = true;
    home-manager.useUserPackages = true;
    home-manager.config = {
      # Example settings
      programs.zsh.enable = true;
      home.stateVersion = "24.05"; # Update this according to your version
    };
  };
}