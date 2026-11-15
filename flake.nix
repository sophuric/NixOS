# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    # Revert NVIDIA to a working version
    nvidia-nixpkgs.url = "github:nixos/nixpkgs/fd1462031fdee08f65fd0b4c6b64e22239a77870";
    # Newer version of Immich
    immich-nixpkgs.url = "github:nixos/nixpkgs/b4fd65b198c599cbe814fcb9f42d25d021595ec9";
    catppuccin = {
      url = "github:catppuccin/nix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
    };
    fluxer = {
      url = "github:Hy4ri/fluxer-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-jetbrains-plugins.url = "github:nix-community/nix-jetbrains-plugins";
    # Pin to version 4.7.0 since 4.7.1 hangs when updating a lot of mods
    ferium-nixpkgs.url = "github:nixos/nixpkgs/dab5a37fb772b3d1a3afa9f568eb0f5aa286d015";
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      ...
    }:
    let
      lib = inputs.nixpkgs.lib;
      util = import ./util.nix (inputs // { inherit lib; });
      configurationNames = [
        "sophie-desktop"
        "sophie-raspberrypi"
      ];
      username = "sophie";
    in
    {
      nixosConfigurations = lib.attrsets.genAttrs configurationNames (
        configurationName:
        (nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit util;
            inherit inputs;
            inherit username;
          };
          modules = [
            ./system/profiles/${configurationName}/configuration.nix
            home-manager.nixosModules.home-manager
            {
              networking.hostName = configurationName;
              home-manager = {
                backupFileExtension = "hm.backup";
                extraSpecialArgs = {
                  inherit util;
                  inherit inputs;
                };
                users.${username}.imports = [ ./user/profiles/${configurationName}/configuration.nix ];
              };
              users.users.${username} = {
                uid = 1000;
                isNormalUser = true;
                description = "Sophie";
              };
            }
          ];
        })
      );
    };
}
