{ config, pkgs, ... }:

{
  imports =
    [
    ];

    environment.systemPackages = with pkgs; [
      curl
      wget
      firefox
      git
      kate
      gparted
      btrfs-assistant
      btrfs-progs
	
      zsh
    ];


    users.users.a = {
      shell = pkgs.zsh;
    };


    # users.users.a = {
    #   packages = with pkgs; [
    #     firefox
    #     tree
    #   ];
    # };


}
