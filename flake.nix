# vim: fixeol eol expandtab tabstop=2 shiftwidth=2

{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin = {
      url = "github:catppuccin/nix/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };
  outputs = args:
    let
      inputs = (args: args // { original-args = args; }) (args // {
        util = import ./util.nix (args // { lib = args.nixpkgs.lib; });
      });
    in {
      nixosConfigurations = {
        sophie-desktop = args.nixpkgs.lib.nixosSystem {
          specialArgs = inputs;
          modules = [
            ./profiles/desktop/configuration.nix
            { networking.hostName = "sophie-desktop"; }
          ];
        };
        sophie-raspberrypi = args.nixpkgs.lib.nixosSystem {
          specialArgs = inputs;
          modules = [
            ./profiles/raspberrypi/configuration.nix
            { networking.hostName = "sophie-raspberrypi"; }
          ];
        };
      };
    };
}
