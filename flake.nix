# vim: fixeol eol expandtab tabstop=2 shiftwidth=2

{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    # Pin to version 4.7.0 since 4.7.1 hangs when updating a lot of mods
    nixpkgs-ferium-patch.url = "github:nixos/nixpkgs/dab5a37fb772b3d1a3afa9f568eb0f5aa286d015";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin = {
      url = "github:catppuccin/nix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-jetbrains-plugins.url = "github:nix-community/nix-jetbrains-plugins";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };
  # thanks to https://github.com/CallMeEchoCodes/NixOS/blob/main/flake.nix
  outputs =
    inputs@{ nixpkgs, ... }:
    let
      lib = inputs.nixpkgs.lib;
      util = import ./util.nix (inputs // { inherit lib; });
    in
    {
      nixosConfigurations = lib.attrsets.genAttrs [ "sophie-desktop" "sophie-raspberrypi" ] (
        name:
        (nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit util;
            self = inputs.self;
            inherit inputs;
          };
          modules = [
            ./profiles/${name}/configuration.nix
            { networking.hostName = name; }
          ];
        })
      );
    };
}
