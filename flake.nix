{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url =  "github:nixos/nixos-hardware";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser.url = "github:0xc000022070/zen-browser-flake";

  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, zen-browser, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations.MacBookAir = nixpkgs.lib.nixosSystem {
        specialArgs = {
        inherit system;
        inherit inputs;
        };
        modules = [ 
          ./configuration.nix
          inputs.home-manager.nixosModules.home-manager
          nixos-hardware.nixosModules.apple-t2
        ];
     };
   };
 }

