##############################################################
# olive's home.nix for t2 macbook (running nixos not darwin) #
##############################################################

{ config, pkgs, system, inputs, lib, ... }:
let
  system = "x86_64-linux";
in
{
  home.username = "olive";
  home.homeDirectory = "/home/olive";
  home.stateVersion = "24.05"; # DO NOT CHANGE VALUE!!!
  
    nixpkgs.config.allowUnfree = true;  

  home.packages = [
    # my favorite packages
    pkgs.zed-editor # my fav IDE
    inputs.zen-browser.packages."${system}".beta # my browser
    pkgs.planify # nice planner app
    pkgs.libreoffice # office software
    pkgs.focuswriter # distraction-free writing
    pkgs.hunspellDicts.en_US # dictionary for spellcheck
    pkgs.ytermusic # tui music thing
    pkgs.zoom-us #zoom
    pkgs.signal-desktop # signal

    # gnome apps
    pkgs.gnome-tweaks # gnome tweaks
    pkgs.gnome-extension-manager # gnome extensions app

    # gnome extensions
    pkgs.gnomeExtensions.blur-my-shell
    pkgs.gnomeExtensions.panel-corners   
    pkgs.gnomeExtensions.rounded-window-corners-reborn
    pkgs.gnomeExtensions.cronomix
    pkgs.gnomeExtensions.gsconnect
    pkgs.gnomeExtensions.compiz-windows-effect
  
    # fonts
    pkgs.fantasque-sans-mono
  ];

  # use this for some weird broken youtube music package
  # nixpkgs.config.permittedInsecurePackages = [
  #   "python3.12-youtube-dl-2021.12.17"
  # ];

  # fonts
  fonts.fontconfig.enable = true;


  home.file = {
   # Not using to manage dots rn (I dont really have any dots to manage)
  };


  # GTK/Gnome Theming (Gruvbox)
  # Need to figure out how to use nix args (???) to enable light/dark user themes at change of toggle   
   gtk = {
    enable = true;
   iconTheme = {
      name = "Gruvbox-Plus-Dark";
      package = pkgs.gruvbox-plus-icons;
   };

   theme = {
     package = pkgs.gruvbox-gtk-theme.override {
        colorVariants = ["dark" "light"];
 	themeVariants = ["green"];};
        name = "Gruvbox-Green-Dark";
   };

   cursorTheme = {
      package = pkgs.capitaine-cursors-themed;
      name = "Capitaine Cursors (Gruvbox)";
      size = 32;
   };

   font = {
      package = pkgs.fantasque-sans-mono;
      size = 10;
      name = "Fantasque Sans Mono";
   };
  };


  # Gnome extensions
  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          blur-my-shell.extensionUuid
          panel-corners.extensionUuid
          caffeine.extensionUuid
          user-themes.extensionUuid
          rounded-window-corners-reborn.extensionUuid
          cronomix.extensionUuid 
          gsconnect.extensionUuid
          compiz-windows-effect.extensionUuid
          native-window-placement.extensionUuid   
      ];
        disabled-extensions = with pkgs.gnomeExtensions; [
          places-status-indicator.extensionUuid
          auto-move-windows.extensionUuid
        ];
  };};};


  # Env variables
  home.sessionVariables = {
    EDITOR = "nano"; # eww i know but im too busy to learn vim rn
    BROWSER = "zen-browser";
  };


  # Enable HM
  programs.home-manager.enable = true;
 
}
