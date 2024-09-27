{ config, pkgs, ... }:

{
  # Define your home manager configuration here.
  home.username = "a";
  home.homeDirectory = "/home/a";

  programs.zsh.enable = true;
  programs.git.enable = true;

  # Add more Home Manager modules as needed
}

