# home.nix
{ pkgs, ... }:

{
  nixpkgs.overlays = [
    # Import the overlay here for home-manager
    (import (builtins.fetchTarball {
      url = "https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz";
    }))
  ];

  home.packages = with pkgs; [
    # other user packages...
  ];

}
