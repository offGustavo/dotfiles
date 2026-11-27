{ config, pkgs, ... }:

let
  cursor = {
    name = "Nordzy-cursors-white";
    package = pkgs.nordzy-cursor-theme;
    size = 24;
  };
in
{
  home.pointerCursor = cursor // {
    gtk.enable = true;
    x11.enable = true;
  };

  dconf.settings."org/gnome/desktop/interface" = {
    cursor-theme = cursor.name;
    cursor-size = cursor.size;
  };

  home.stateVersion = "26.05";
}
