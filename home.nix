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


users.users.a.isNormalUser = true;
home-manager.users.a = { pkgs, ... }: {
    home.packages = [ pkgs.zsh ];
    programs.zsh.enable = true;
    # The state version is required and should stay at the version you originally installed.
    home.stateVersion = "24.05";
};

