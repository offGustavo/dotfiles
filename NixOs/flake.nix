{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    oxwm.url = "github:tonybanters/oxwm";
    oxwm.inputs.nixpkgs.follows = "nixpkgs";

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, oxwm, nix-flatpak, home-manager, ... }:
  {
    nixosConfigurations.FrankenNix = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";


      modules = [
        ./configuration.nix

        oxwm.nixosModules.default
        nix-flatpak.nixosModules.nix-flatpak

        home-manager.nixosModules.home-manager

        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.gustavo = {
            home.stateVersion = "24.05";

            imports = [
            ];

          };
        }
      ];
    };
  };
}
