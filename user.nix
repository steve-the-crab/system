{ config, pkgs, ... }:

{
  imports =
    [ 
    #   <home-manager/nixos>
    ];


    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.a = {
        isNormalUser = true;
        extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.

        # hashedPassword = "RUN `mkpasswd -m sha-512` TO GENERATE IT";

        # packages = with pkgs; [
        #     zsh
        #     tree
        # ];  


        # programs.zsh.enable = true;
        # programs.git.enable = true;

        
        # home.username = "a";
        # home.homeDirectory = "/home/a";

    };

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

}
