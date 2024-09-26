{ config, pkgs, ... }:

{
  imports =
    [
    ];

    environment.systemPackages = with pkgs; [
        curl
	wget
        firefox
        gcc
        git
        kate
        gparted
        btrfs-assistant
	vscode
	
    ];




    # users.users.a = {
    #   packages = with pkgs; [
    #     firefox
    #     tree
    #   ];
    # };


}
