# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  # neovim-src,
  lib,
  ...
}:
let
  sources = import ./lon.nix;
  lanzaboote = import sources.lanzaboote {
    inherit pkgs;
  };
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # Secure Boot
    lanzaboote.nixosModules.lanzaboote 
  ];

  # # Set the swapfile
  # swapDevices = [
  #   {
  #     device = "/swapfile";
  #     size = 4096;
  #   }
  # ]; # 4GB in /swap directory

  zramSwap.enable = true;

  # Bootloader.

  # Lanzaboote currently replaces the systemd-boot module.
  # This setting is usually set to true in configuration.nix
  # generated at installation time. So we force it to false
  # for now.
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  # # boot.loader.limine.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  # boot.tmp.cleanOnBoot = true;
  # boot.kernelParams = [
  #   # NVIDIA DRM modeset
  #   "nvidia-drm.modeset=1"
  #   # Fix sleep/wake issues
  #   "mem_sleep_default=deep"
  #   "nouveau.modeset=0"
  #   # PCI power management
  #   "pcie_aspm.policy=powersupersave"
  # ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  hardware.keyboard.qmk.enable = true;
  services.udev.packages = with pkgs; [ via ];

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [
    "nvidia"
  ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Shows battery charge of connected devices on supported
        # Bluetooth adapters. Defaults to 'false'.
        Experimental = true;
        # When enabled other devices can connect faster to us, however
        # the tradeoff is increased power consumption. Defaults to
        # 'false'.
        FastConnectable = true;
      };
      Policy = {
        # Enable all controllers when they are found. This includes
        # adapters present on start as well as adapters that are plugged
        # in later on. Defaults to 'true'.
        AutoEnable = true;
      };
    };
  };

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    open = true;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # # -- Fix gnome and kde
  # programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.seahorse.out}/libexec/seahorse/ssh-askpass";

  services = {
    # Enable the X11 windowing system.
    # You can disable this if you're only using the Wayland session.
    xserver = {
      enable = true;
      # desktopManager = {
      #   xterm.enable = false;
      # };
      windowManager = {
        # awesome.enable = true;
        # qtile.enable = true;
        i3 = {
          enable = true;
          extraPackages = with pkgs; [
            dmenu # application launcher most people use
            i3status # gives you the default i3 status bar
            i3blocks # if you are planning on using i3blocks over i3status
            arandr
            xwallpaper
            flameshot
            xclip
            rofi
            alacritty
          ];
        };
        # session = [
        #   {
        #     name = "exwm";
        #     start = ''
        #       emacs --daemon
        #       exec emacsclient -c -a "" \
        #       --eval "(progn (require 'exwm) (exwm-wm-mode))"
        #     '';
        #   }
        # ];
      };
    };

    # # Enable the KDE Plasma Desktop Environment.
    # displayManager.sddm.wayland.enable = true;
    # displayManager.sddm.enable = true;
    # desktopManager.plasma6.enable = true;

    # Gnome
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    # # Enable the COSMIC login manager
    # displayManager.cosmic-greeter.enable = true;
    # desktopManager.cosmic.enable = true;
    # system76-scheduler.enable = true;

    # Configure keymap in X11
    xserver.xkb = {
      layout = "us";
      variant = "intl";
    };

    flatpak.enable = true;
    # Enable Flatpak
    # nix-flatpak.packages = [
    #   "com.obsproject.Studio"
    #   "com.mattjakeman.extensionmanager"
    #   "app.zen_browser.zen"
    #   "io.github.flattool.warehouse"
    # ];

  };

  # specialisation = {
    # kde.configuration = {
      # desktopManager.gnome.enable = lib.mkForce false;
      # displayManager.gdm.enable = lib.mkForce false;
      # services.displayManager.sddm.enable = true;
      # services.desktopManager.plasma6.enable = true;
    # };
  # };
  # #   gnomo = {
  # #     # inheritParentConfig = false;
  # #     configuration = {
  # #       # system.nixos.tags = [ "gnome" ];
  # #       services = {
  # #         displayManager.sddm.enable = lib.mkForce false;
  # #         desktopManager.plasma6.enable = lib.mkForce false;
  # #         desktopManager.gnome.enable = true;
  # #         displayManager.gdm.enable = true;
  # #       };
  # #       # users.users.paul = {
  # #       #   isNormalUser = true;
  # #       #   uid = 1002;
  # #       #   extraGroups = [ "networkmanager" "video" ];
  # #       # };
  # #     #   services.xserver.displayManager.autoLogin = {
  # #     #     enable = true;
  # #     #     user = "paul";
  # #     #   };
  # #     #   environment.systemPackages = with pkgs; [
  # #     #     dune-release
  # #     #   ];
  # #     };
  # #   };
  # };

  # Configure console keymap
  console.keyMap = "us-acentos";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gustavo = {
    isNormalUser = true;
    description = "gustavo";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "input"
      "uinput"
    ];
    shell = pkgs.fish;
    packages = with pkgs; [
      # claude-code
      kitty
      vscode
      # zed-editor
      lazygit
      google-chrome
      # vivaldi
      yazi
      tmux
      fastfetch
      # libsForQt5.qtstyleplugin-kvantum
      gcc
      gnumake
      cmake
      # libvterm
      # emacs-vterm
      # emacs
      # texlive
      neovide
      kanata
      niri
      hyprlock
      gsettings-desktop-schemas
      xdg-desktop-portal-gtk
      fuzzel
      wayscriber
      darkman
      # neovide
      # vim
      vis
      qmk
      # vial
      keypunch
      gradia
      obs-studio
      # TODO: add android camera plugin
      pwvucontrol
      via
      # vivaldi
      # google-chrome
      # Gnome Apps
      gnome-tweaks
      gnome-boxes
      gparted
      heroic
      prismlauncher
      refine # Gnome
      wget
      rustc
      rustup
      go
      cargo
      lua
      jq
      luarocks
      moreutils
      git
      swaybg
      mission-center
      waybar
      quickshell
      lua-language-server
      stylua
      nil
      bash-language-server
      nodejs
      marksman
      rust-analyzer
      typescript-language-server
      pokeget-rs
      ripgrep
      bat
      fd
      eza
      zip
      unzip
      fzf
      zoxide
      xwayland-satellite
      fuzzel
      rofi
      rofimoji
      wlsunset
      playerctl
      brightnessctl
      wl-clipboard
      mako
      adw-bluetooth
      nmgui
    ];
  };

  # (psygreg)
  fonts.packages = with pkgs; [
    nerd-fonts.adwaita-mono
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    cantarell-fonts
    poppins
  ];

  programs.dms-shell = {
    enable = true;

    systemd = {
      enable = false; # Systemd service for auto-start
      # restartIfChanged = true;   # Auto-restart dms.service when dms-shell changes
    };

    # Core features
    # enableSystemMonitoring = true;     # System monitoring widgets (dgop)
    #   enableClipboard = true;            # Clipboard history manager
    #   enableVPN = true;                  # VPN management widget
    #   enableDynamicTheming = true;       # Wallpaper-based theming (matugen)
    #   enableAudioWavelength = true;      # Audio visualizer (cava)
    #   enableCalendarEvents = true;       # Calendar integration (khal)
  };

  programs = {
    # Install firefox.
    firefox.enable = true;

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      configure = {
#   customRC = ''
# " Find
# set findfunc=Find
# func Find(arg, _)
#   if empty(s:filescache)
#     let s:filescache = globpath('.', '**', 1, 1)
#     call filter(s:filescache, '!isdirectory(v:val)')
#     call map(s:filescache, "fnamemodify(v:val, ':.')")
#   endif
#   return a:arg == '''''' ? s:filescache : matchfuzzy(s:filescache, a:arg) 
# endfunc
# let s:filescache = []
# autocmd CmdlineEnter : let s:filescache = []
#
# nmap <M-o> :find 
# nmap <M-s> :grep 
# nmap <M-b> :b 
# nmap <M-e> <Cmd>Ex<Cr> 
#   '';
      };
    };

    # Shell
    fish.enable = true;
    zsh.enable = true;

    # Fix the liked
    nix-ld.enable = true;

    niri.enable = true;
    # hyprland.enable = true;

    virt-manager.enable = true;

    # steam setup
    steam = {
      enable = true;
      #   remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      #   dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };
    # gamescope setup
    # gamescope = {
    #   enable = true;
    #   capSysNice = false;
    # };

    gamescope.enable = true;
    gamemode.enable = true;

  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  #   nixpkgs.overlays = [
  #   (final: prev: {
  #     neovim = prev.neovim.overrideAttrs (old: {
  #       src = neovim-src;
  #       version = "master";
  #       # Let nix tell you the correct hash first
  #       vendorHash = null;
  #     });
  #   })
  # ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Secure Boot
    sbctl
    neovim
    podman-compose
    distrobox
    (distrobox.overrideAttrs (oldAttrs: {
      postInstall = (oldAttrs.postInstall or "") + ''
        for file in $out/bin/*; do
                              sed -i 's|distrobox_path="$(dirname "$(realpath "$0")")"|distrobox_path="/run/current-system/sw/bin"|g' "$file"
                              sed -i 's|distrobox_path="$(dirname "$(readlink -f "$0")")"|distrobox_path="/run/current-system/sw/bin"|g' "$file"
                              done
      '';
    }))
  ];

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true; # Required for cont>
    };
    libvirtd = {
      enable = true;
    };
    spiceUSBRedirection.enable = true;
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 5d";
    };
  };

  # systemd.services.kanata = {
  #   enable = true;
  #   description = "Kanata - Keyboard Remapper";
  #   wantedBy = [ "default.target" ];
  #   serviceConfig = {
  #     ExecStart = "${pkgs.kanata}/bin/kanata --cfg /home/gustavo/.config/kanata/kanata.kbd";
  #     Restart = "no";
  #     RestartSec = 3;
  #     Nice = -20;
  #   };
  # };

  # enable flathub (psygreg)
  # systemd.services.flatpak-repo = {
  #   wantedBy = [ "multi-user.target" ];
  #   path = [ pkgs.flatpak ];
  #   script = ''
  #     flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  #   '';
  # };

  # environment.etc."usr/bin/flatpak".source = "/run/current-system/sw/bin/flatpak";

  environment.variables = {
    # XDG_CONFIG_HOME = "$HOME/.config";
    # ZDOTDIR = "$XDG_CONFIG_HOME/zsh";
    # HISTFILE = "$XDG_CONFIG_HOME/zsh/.zsh_history";
    EDITOR = "nvim";
  };

  # # Some programs need SUID wrappers, can be configured further or are
  # # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

  # # Dangerous things
  # system.autoUpgrade.enable = true;
  # system.autoUpgrade.allowReboot = true;

}
