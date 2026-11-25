{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05"; # stable
    # nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    wayscriber.url = "github:devmobasa/wayscriber";

    niri.url = "github:sodiboo/niri-flake";
    # no niri.inputs.nixpkgs.follows
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-flatpak,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };

        modules = [
          ./configuration.nix
          home-manager.nixosModules.default
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; }; # If you want access to inputs in your home.nix
              users.gustavo = ./home.nix; # replace <USERNAME> with your actual username
            };
          }
        ];
      };
    };
}
