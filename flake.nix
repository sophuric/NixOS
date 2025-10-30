# vim: fixeol eol expandtab tabstop=2 shiftwidth=2

{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser.inputs.home-manager.follows = "home-manager";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    catppuccin.url = "github:catppuccin/nix/release-25.05";
  };
  outputs = args:
    let inputs = (import ./util.nix args);
    in {
      nixosConfigurations.sophie = args.nixpkgs.lib.nixosSystem {
        specialArgs = inputs;
        modules = [
          args.catppuccin.nixosModules.catppuccin
          ./configuration.nix
          args.home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = inputs;
              users.sophie = {
                imports = [
                  args.catppuccin.homeModules.catppuccin
                  ./home/sophie/sophie.nix
                ];
              };
            };
          }
        ];
      };
    };
}
