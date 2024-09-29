{ config, pkgs, ... }:

# let
#     home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
# in
{
    imports = [
        # (import "${home-manager}/nixos")
    ];

    users.users.a = {
        isNormalUser = true;
        extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    };

    users.defaultUserShell=pkgs.zsh; 


    # enable zsh and oh my zsh
    programs = {
        zsh = {
            enable = true;
            autosuggestions.enable = true;
            zsh-autoenv.enable = true;
        };
    };


    


    # home-manager.users.a = {
    #     /* The home.stateVersion option does not have a default and must be set */
    #     home.stateVersion = "24.05";
    #     /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
    #     home.packages = [ pkgs.zsh ];

    # };

    # programs.zsh.enable = true;
}




# {
#   imports =
#     [ 
#     #   <home-manager/nixos>
#     ];


# Define a user account. Don't forget to set a password with ‘passwd’.
# users.users.a = {
#     isNormalUser = true;
#     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.

# hashedPassword = "RUN `mkpasswd -m sha-512` TO GENERATE IT";

# packages = with pkgs; [
#     zsh
#     tree
# ];  


# programs.zsh.enable = true;
# programs.git.enable = true;


# home.username = "a";
# home.homeDirectory = "/home/a";

# };

#     # Enable Home Manager
#     home-manager = {
#         useGlobalPkgs = true;
#         useUserPackages = true;
#     };



#   home-manager.config = {
#     # Enable Zsh as the shell
#     programs.zsh.enable = true;

#     # Configure Git
#     programs.git = {
#       enable = true;
#       userName = "a";
#       userEmail = "your-email@example.com";
#     };

#     home.stateVersion = "24.05";
#   };

# }
