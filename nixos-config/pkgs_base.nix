{ config, pkgs, ... }:

{
  imports =
    [
    ];

    environment.systemPackages = with pkgs; [
      nix-serve

      curl
      wget
      firefox
      git
      kate
      gparted

      btrfs-assistant
      btrfs-progs
      snapper
	
      zsh
      zsh-powerlevel10k
      fasd        # if you use fasd
      mcfly       # if you use mcfly for ctrl-r history


      docker
      qemu_full
      qemu-utils


      


    ];




    # zsh
    # programs.zsh.enable = true;


    # users.users.a = {
    #   shell = pkgs.zsh;
    # };


    # users.users.a = {
    #   packages = with pkgs; [
    #     firefox
    #     tree
    #   ];
    # };


}
