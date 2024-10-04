{ config, pkgs, ... }:

{
  imports =
    [
    ];

    environment.systemPackages = with pkgs; [
        curl
        android-tools
        arduino
        cc65
        clang
        # cuda
        docker
        docker-compose
        filezilla
        gcc
        git
        git-lfs
        kate
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
        rustup
        rye
        stripe-cli
        vice
        vscode-fhs
        wavemon
        xdotool
        wget
        wmctrl


    ];




    # rustup

  system.activationScripts.rustup = ''
    ${pkgs.rustup} default nightly
  '';




    # runuser -l <username> -c 'if [ ! -f "/home/<username>/.cargo/bin/rustc" ]; then

  # system.activationScripts.rustup = ''
  #   runuser -l a -c 'if [ ! -f "/home/a/.cargo/bin/rustc" ]; then
  #       ${pkgs.curl}/bin/curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | ${pkgs.bash}/bin/bash -s -- -y
  #       /home/a/.cargo/bin/rustup install stable
  #       /home/a/.cargo/bin/rustup install nightly
  #   fi'
  # '';



# system.activationScripts.rustup = ''
#   sudo -u <username> bash -c 'if [ ! -f "$HOME/.cargo/bin/rustc" ]; then
#     rustup install stable
#     rustup install nightly
#   fi'
# '';




  # systemd.user.services.rustup-install = {
  #   description = "Install Rust using rustup on first install";
  #   wantedBy = [ "default.target" ];
  #   serviceConfig = {
  #     ExecStart = ''
  #       if [ ! -f "$HOME/.cargo/bin/rustc" ]; then
  #         rustup install stable
  #         rustup install nightly
  #       fi
  #     '';
  #     Type = "oneshot";
  #     RemainAfterExit = true;
  #   };
  # };




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
