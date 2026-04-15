{ config, pkgs, lib, ... }:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # XDG portal for Wayland compositors
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  # Group all Hypr* utilities in ONE package
  environment.systemPackages = with pkgs; [
    hyprcursor
    hyprpicker
    hyprshot
    hyprsunset
    hyprland-protocols
    swaybg
    waybar
    fuzzel
    rose-pine-hyprcursor
    playerctl
    brightnessctl
    wl-clipboard
    # GUI
    swaynotificationcenter
    adw-bluetooth
    pavucontrol
    libnotify
  ];
}

