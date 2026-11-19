{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";   # stable
    # nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    wayscriber.url = "github:devmobasa/wayscriber";

    niri.url = "github:sodiboo/niri-flake";
    # no niri.inputs.nixpkgs.follows
  };

  outputs = { self, nixpkgs,  nix-flatpak, ... }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };

        modules = [
          ./configuration.nix
          # niri.nixosModules.niri
          # {
          #   programs.niri.package = niri.packages.${system}.niri-unstable;
          # }
        ];
      };
    };
}
