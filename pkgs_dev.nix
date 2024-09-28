{ config, pkgs, ... }:

{
  imports =
    [
    ];

    environment.systemPackages = with pkgs; [
        curl
        wget
        git
        kate
        android-tools
        arduino
        cc65
        clang
        cuda
        docker
        docker-compose
        filezilla
        git
        git-lfs
        kate
        lazydocker
        lazygit
        mkcert
        mold
        npm
        perf
        php
        php-sqlite
        pv
        python
        qemu-base
        qemu-common
        qemu-full
        qemu-img
        qemu-system-x86
        qemu-system-x86-firmware
        rsync
        stripe-cli
        vice
        visual-studio-code-bin
        wavemon
        wmctrl
        xdotool


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
