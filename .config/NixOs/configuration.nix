# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(4) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, unstable, nix-flatpak, inputs, ... }:

{
	imports =
		[ # Include the results of the hardware scan.
			./hardware-configuration.nix
			./modules/hyprland.nix
		];

# Bootloader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

# Use latest kernel.
	boot.kernelPackages = pkgs.linuxPackages_latest;

	networking.hostName = "FrankenNix"; # Define your hostname.
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

# environment.variables = {
#   GTK_IM_MODULE = "cedilla";
#   QT_IM_MODULE = "cedilla";
# };

# Enable the X11 windowing system.
services.xserver = {
  enable = true;
  # desktopManager.xfce.enable = true;
  # windowManager.i3.enable = true;
  windowManager.oxwm.enable = true;
  # windowManager.session = [{
  #   name = "exwm";
  #   start = ''
  #     # IMPORTANTE: iniciar o Emacs como *daemon* antes de abrir a GUI
  #     emacs --daemon
  #
  #     # Agora iniciar o EXWM de verdade
  #     exec emacsclient -c -a "" \
  #       --eval "(progn (require 'exwm) (exwm-wm-mode))"
  #   '';
  # }];
  excludePackages = [ pkgs.xterm ];
};

hardware.opengl = {
  enable = true;
  # driSupport = true;
  # driSupport32Bit = true;
  # extraPackages = with pkgs; [
  #   intel-compute-runtime
  #   intel-media-driver
  #   intel-vaapi-driver
  #   libvdpau-va-gl
  # ];
  # extraPackages32 = with pkgs; [
  #   driversi686Linux.vaapiIntel
  # ];
};

# Load nvidia driver for Xorg and Wayland
services.xserver.videoDrivers = [ "nvidia" ];

hardware.nvidia = {
  modesetting.enable = true;
  powerManagement.enable = false;
  powerManagement.finegrained = false;
  open = false;
  nvidiaSettings = false;
  package = config.boot.kernelPackages.nvidiaPackages.stable;
  
  prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    # Bus IDs - you may need to adjust these
    intelBusId = "PCI:0:0:0";
    nvidiaBusId = "PCI:1:0:0";
  };
};

  # Enable the GNOME Desktop Environment.
	services.displayManager.gdm.enable = true;
	services.desktopManager.gnome.enable = true;
  # environment.gnome.games.enable = false;
  environment.gnome.excludePackages = with pkgs; [ epiphany geary  gnome-tour gnome-user-docs ];

  # services.displayManager = {
  #   sddm = {
  #     enable = true;
  #     wayland.enable = true;
  #   };
  # };
  # services.desktopManager.plasma6.enable = true;
  # programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.seahorse.out}/libexec/seahorse/ssh-askpass";

  # Enable the COSMIC login manager
  # services.displayManager.cosmic-greeter.enable = true;

  # Enable the COSMIC desktop environment
  # services.desktopManager.cosmic.enable = true;

  # Fix the liked 
  programs.nix-ld.enable = true;

# Configure keymap in X11
	services.xserver.xkb = {
		layout = "us";
		variant = "altgr-intl";
	};

# Configure console keymap
console.keyMap = "us";

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
		shell = pkgs.zsh; 
		extraGroups = [ "networkmanager" "wheel" "podman" ];
		packages = with pkgs; [
			zsh
      kitty
      wezterm
      jq
      lazygit
      stow
      fastfetch
      zed-editor
      helix
      emacs
      pokeget-rs
      ripgrep
      fd
      eza
      bat
      tree-sitter
      lua-language-server
      nil
      bash-language-server
      marksman
      rust-analyzer
      typescript-language-server
      zip
      unzip
      fzf
      tmux 
      zoxide
      distrobox
      # TODO: remove this
      gnome-tweaks
		];
	};

   # enable flathub (psygreg)
   systemd.services.flatpak-repo = {
     wantedBy = [ "multi-user.target" ];
     path = [ pkgs.flatpak ];
     script = ''
       flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
     '';
   };

  services = {
    # enable nix-flatpak declarative flatpaks
    flatpak = {
      enable = true;
      packages = [
      # "com.mattjakeman.extensionmanager"
      # "app.zen_browser.zen"
      # "com.google.chrome"
      # "io.github.kolunmi.bazzar"
      # "io.github.flattool.warehouse"
      # "com.obsproject.Studio"
      # "com.valvesoftware.Steam"
      # "com.vivaldi.Vivaldi"
      ];
    };
  };

  environment.etc."usr/bin/flatpak".source = "/run/current-system/sw/bin/flatpak";

  programs = {
# Install firefox.
    firefox.enable = true;

#  Zsh+ohMyZsh
    zsh = {
      enable = true;
      ohMyZsh = {
        enable = true;
        theme = "smt";
        plugins = [
          "vi-mode"
          "git"
        ];
      };
    };

# steam setup
    # steam = {
    #   enable = true;
    #   remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    #     dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    # };
# gamescope setup
    gamescope = {
      enable = true;
      capSysNice = false;
    };
  };

	environment.variables = {
		XDG_CONFIG_HOME="$HOME/.config";
		ZDOTDIR="$XDG_CONFIG_HOME/zsh";
    HISTFILE="$XDG_CONFIG_HOME/zsh/.zsh_history";
    EDITOR="nvim";
	};

# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

systemd.services.kanata-custom = {
  enable = true;
  description = "kanata (custom service)";

  wantedBy = [ "default.target" ];

  serviceConfig = {
    ExecStart = "${pkgs.kanata}/bin/kanata --cfg /home/gustavo/.config/kanata/kanata.kbd";
    Restart = "no";
    RestartSec = 3;
    Nice = -20;
  };
};

# 	environment.sessionVariables = {
# 		# If your cursor becomes invisible
# 			WLR_NO_HARDWARE_CURSORS = "1";
# 		# Hint electron apps to use wayland
# 			NIXOS_OZONE_WL = "1";
# 	};
# 
# 	hardware = {
# # Opengl
# 		opengl.enable = true;
# 
# # Most wayland compositors need this
# 			nvidia.modesetting.enable = true;
# 	};
# 
# # waybar
# 	(pkgs.waybar.overrideAttrs (oldAttrs: {
# 				    mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
# 				    })
# 	)
# 
# # XDG portal
		xdg.portal.enable = true;
	xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

# List packages installed in system profile. To search, run:
# $ nix search wget
	environment.systemPackages = with pkgs; [
    wget
    gcc
    rustc
    rustup
    lua
    python315
    cmake
    gnumake
    git
    libtool
    vim
    kanata
    pulseaudio
    gparted
	];

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

# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# programs.mtr.enable = true;
# programs.gnupg.agent = {
#   enable = true;
#   enableSSHSupport = true;
# };
#
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true; # Required for cont>
    };
  };

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 5d";
  };

# List services that you want to enable:

# Enable the OpenSSH daemon.
# services.openssh.enable = true;

# Open ports in the firewall.
networking.firewall = {
  enable = true;
  allowedTCPPorts = [];
  allowedUDPPorts = [];
};
# Or disable the firewall altogether.
# networking.firewall.enable = false;

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "25.11"; # Did you read the comment?
}
