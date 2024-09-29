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
        # cuda
        docker
        docker-compose
        filezilla
        git
        git-lfs
        lazydocker
        lazygit
        mkcert
        mold
        nodejs_22
        linuxKernel.packages.linux_zen.perf
        php
        php83Extensions.sqlite3
        pv
        python3
        rsync
        rye
        stripe-cli
        vice
        vscode-fhs
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
