########################################################################################
# olive's nixOS config file for the T2 mac (has messed up syntax highlighting idk why) #
########################################################################################


{ config, lib, pkgs, inputs, system, ... }:

{
  imports =
    [ # import hardware info
      ./hardware-configuration.nix
    ];

  # systemd-boot EFI boot loader
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
  };

  # T2 apple firmware (WARNING TAKES FOREVER TO COMPILE!!!)
  # apple sucks so unforch the whole kernal has to compile everytime the flake is updated
  hardware.enableAllFirmware = true;
  hardware.firmware = [
    (pkgs.stdenvNoCC.mkDerivation  {
       name = "brcm-firmware";

       buildCommand = ''
         dir="$out/lib/firmware"
         mkdir -p "$dir"
         cp -r ${./firmware}/* "$dir"
      '';
     })
  ];
  nixpkgs.config.allowUnfree = true; # needed for firmware to work


  # various hardware modules, like camera and bluetooth
  hardware.facetimehd.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
 
  networking.hostName = "MacBookAir";
  networking.wireless.enable = false;  # wpa_supplicant
  # networking.wireless.userControlled.enable = true; # other networking option, prob dont use
  networking.networkmanager.enable = true;  # network manager
 
 # local send firewall port settings/program
 programs.localsend = {
    enable = true;
    openFirewall = true;
  };

   # time zone and locale
   time.timeZone = "America/Denver";

   i18n.defaultLocale = "en_US.UTF-8";
   console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkb.options in tty (idk what this is)
   };

  # X11 windowing system (ewwww but needed for xwayland)
  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    desktopManager.gnome.enable = true;
  };

  # get rid of some gnome default apps
  environment.gnome.excludePackages = (with pkgs;[
    atomix
    epiphany
    gedit 
    gnome-terminal
    gnome-console 
    xterm
    gnome-user-docs
    gnome-connections
 
    # get rid of some default extensions
    gnomeExtensions.applications-menu
    gnomeExtensions.launch-new-instance    
    gnomeExtensions.light-style
    gnomeExtensions.screenshot-window-sizer
    gnomeExtensions.status-icons
    gnomeExtensions.system-monitor
    gnomeExtensions.window-list    
    gnomeExtensions.windownavigator
    gnomeExtensions.workspace-indicator
    ] );  

  # CUPS printing
  services.printing.enable = true;

  # audio
  # hardware.pulseaudio.enable = true; # probably dont use this option
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };


  # user account
  users.users.olive = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
        tree # needed for tree view, helpful for GTK theming
   ];
  };

  # enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # my home-manager set up
  home-manager = {
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs; };
    users = {
     "olive" = import ./home.nix;
    };
  };

  # only the basic packages, the rest are in home manager
  environment.systemPackages = with pkgs; [
    nano
    wget
    kitty
    git 
    home-manager
  ];

  system.stateVersion = "25.05"; # WARNING DO NOT CHANGE THIS!!!!

}

