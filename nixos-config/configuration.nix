{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./hardware-configuration-changes.nix
      ./luks.nix
      # ./audio.nix
      # ./bluetooth.nix
      ./pkgs_base.nix
      # ./pkgs_dev.nix
      ./user.nix
    ];


    services.spice-vdagentd.enable = true;

    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.supportedFilesystems = [ "btrfs" ];
    hardware.enableAllFirmware = true;
    nixpkgs.config.allowUnfree = true;

    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "nixos"; # Define your hostname.
    # Pick only one of the below networking options.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

    # Set your time zone.
    time.timeZone = "Europe/London";

    # Configure network proxy if necessary 
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Select internationalisation properties. 
    i18n.defaultLocale = "en_GB.UTF-8";
    # console = {
    # #   font = "Lat2-Terminus16";
    #     keyMap = "uk";
    # #   useXkbConfig = true; # use xkbOptions in tty.
    # };
    # Configure keymap in X11
    services.xserver.xkb.layout = "gb";

    # Enable touchpad support (enabled default in most desktopManager).
    services.libinput.enable = true;

    # Enable X11
    services.xserver.enable = true;
    services.displayManager.sddm.enable = true; # SDDM is recommended for KDE Plasma
    services.xserver.desktopManager.plasma5.enable = true;

    # # Define a user account. Don't forget to set a password with ‘passwd’.
    # users.users.a = {
    #   isNormalUser = true;
    #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    #   # hashedPassword = "RUN `mkpasswd -m sha-512` TO GENERATE IT";
    #   #   packages = with pkgs; [
    #   #     firefox
    #   #     tree
    #   #   ];  
    #   home.username = "a";
    #   home.homeDirectory = "/home/a";

    #   programs.zsh.enable = true;
    #   programs.git.enable = true;
    # };

    # # Enable Home Manager
    # home-manager = {
    #     useGlobalPkgs = true;
    #     useUserPackages = true;
    # };



  # home-manager.config = {
  #   # Enable Zsh as the shell
  #   programs.zsh.enable = true;

  #   # Configure Git
  #   programs.git = {
  #     enable = true;
  #     userName = "a";
  #     userEmail = "your-email@example.com";
  #   };

  #   home.stateVersion = "24.05";
  # };




    # fonts = {
    #   enableDefaultFonts = true;
    #   fontsDirs = [ "/etc/nixos/fonts" ];
    # };


    system.stateVersion = "24.05";
}
