{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    # inputs.dms.url = "github:AvengeMedia/DankMaterialShell";

    wayscriber.url = "github:devmobasa/wayscriber";
    # neovim-src = {
    #   url = "github:neovim/neovim?ref=master";
    #   flake = false;
    # };
  };

# neovim-src,
outputs =
  { self, nixpkgs, nix-flatpak,  ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        ./configuration.nix
        # nix-flatpak.nixosModules.nix-flatpak

        # ({ config, pkgs, ... }: {
        #   nixpkgs.overlays = [
        #     (final: prev: {
        #       neovim = prev.neovim.overrideAttrs (old: {
        #         src = neovim-src;
        #       });
        #     })
        #   ];
        #
        #   environment.systemPackages = with pkgs; [
        #     neovim
        #   ];
        # })
      ];
    };
  };
}
