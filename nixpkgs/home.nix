{ pkgs, ... }:

{
  # Home Manager state version
  home.stateVersion = "24.05";
  
  # Define your home manager configuration here.
  home.username = "a";
  home.homeDirectory = "/home/a";


  # Enable zsh and set it as the default shell for your user
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    history = 10000;
    shellAliases = {
      ll = "ls -al";
      grep = "grep --color=auto";
    };
  };

  # Set zsh as your default shell
  home.shell = pkgs.zsh;

  # Example zsh plugin configuration
  programs.zsh.ohMyZsh.enable = true;
  programs.zsh.ohMyZsh.theme = "robbyrussell";  # You can set your preferred theme here
  programs.zsh.ohMyZsh.plugins = [ "git" "z" "colored-man-pages" ];

}