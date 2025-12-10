# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
	imports =
		[ # Include the results of the hardware scan.
		./hardware-configuration.nix
		];

# Bootloader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

# Use latest kernel.
	boot.kernelPackages = pkgs.linuxPackages_latest;

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

# Enable the X11 windowing system.
services.xserver = {
  enable = true;

  windowManager.session = [{
    name = "exwm";
    start = ''
      # IMPORTANTE: iniciar o Emacs como *daemon* antes de abrir a GUI
      emacs --daemon

      # Agora iniciar o EXWM de verdade
      exec emacsclient -c -a "" \
        --eval "(progn (require 'exwm) (exwm-enable))"
    '';
  }];
};

# Enable OpenGL
	hardware.graphics = {
		enable = true;
	};

# Load nvidia driver for Xorg and Wayland
	services.xserver.videoDrivers = ["nvidia"];

	hardware.nvidia = {

# Modesetting is required.
		modesetting.enable = true;

# Nvidia power management. Experimental, and can cause sleep/suspend to fail.
# Enable this if you have graphical corruption issues or application crashes after waking
# up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
# of just the bare essentials.
		powerManagement.enable = false;

# Fine-grained power management. Turns off GPU when not in use.
# Experimental and only works on modern Nvidia GPUs (Turing or newer).
		powerManagement.finegrained = false;

# Use the NVidia open source kernel module (not to be confused with the
# independent third-party "nouveau" open source driver).
# Support is limited to the Turing and later architectures. Full list of 
# supported GPUs is at: 
# https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
# Only available from driver 515.43.04+
		open = false;

# Enable the Nvidia settings menu,
# accessible via `nvidia-settings`.
		nvidiaSettings = true;

# Optionally, you may need to select the appropriate driver version for your specific GPU.
		package = config.boot.kernelPackages.nvidiaPackages.stable;
	};

  services.xserver.windowManager.i3.enable = true;
  # Enable the GNOME Desktop Environment.
	services.displayManager.gdm.enable = true;
	services.desktopManager.gnome.enable = true;
  # envirioment.gnome.games.enable = false;
  # envirioment.gnome.excludePackages = with pkgs; [ totem epiphany gnome-software geary gnome-music gnome-tour gnome-user-docs ];

  # services.displayManager = {
  #   sddm = {
  #     enable = true;
  #     wayland.enable = true;
  #   };
  # };
  # services.desktopManager.plasma6.enable = true;

# Configure keymap in X11
	services.xserver.xkb = {
		layout = "us";
		variant = "intl";
	};

# Configure console keymap
# console.keyMap = "us-acentos";

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
		extraGroups = [ "networkmanager" "wheel" ];
		packages = with pkgs; [
			zsh
      kitty
      jq
      lazygit
      # flatpak
      # gnome-software
		];
	};


  # # enable flathub (psygreg)
  # systemd.services.flatpak-repo = {
  #   wantedBy = [ "multi-user.target" ];
  #   path = [ pkgs.flatpak ];
  #   script = ''
  #     flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  #   '';
  # };

  services = {
    # enable nix-flatpak declarative flatpaks
    flatpak = {
      enable = true;
    #   packages = [
    #   "com.mattjakeman.ExtensionManager"
    #   "app.zen_browser.zen"
    #   "com.google.Chrome"
    #   "io.github.kolunmi.Bazzar"
    #   "io.github.flattool.Warehouse"
    #   ];
    #   update.auto = {
    #     enable = true;
    #     onCalendar = "daily";
    #   };
    };
  };

  environment.etc."usr/bin/flatpak".source = "/run/current-system/sw/bin/flatpak";


  # enable nix-flatpak declarative flatpaks(psygreg)
  # services.flatpak.enable = true;
  #   enable = true;
  #   packages = [
  #     "com.mattjakeman.ExtensionManager"
  #     "app.zen_browser.zen"
  #     "com.google.Chrome"
  #     "io.github.kolunmi.Bazzar"
  #     "io.github.flattool.Warehouse"
  #     "org."
  #   ];
  #   update.auto = {
  #     enable = true;
  #     onCalendar = "daily";
  #   };
  # };

# Install firefox.
	programs.firefox.enable = true;

	programs.zsh = {
		enable = true;
	};

	environment.variables = {
		XDG_CONFIG_HOME="$HOME/.config";
		ZDOTDIR="$XDG_CONFIG_HOME/zsh";
    HISTFILE="$XDG_CONFIG_HOEM/zsh/.zsh_history";
	};

# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	programs.hyprland = {
		enable = true;
		xwayland.enable = true;
	};

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
    cmake
    gnumake
    git
    emacs
    fzf
    tmux 
    zoxide
    neovim
    kanata
    ripgrep
    fd
    eza
    bat
    zip
    unzip
    lua
    fastfetch
    pokeget-rs
    swaybg
    hyprshot
    waybar
    fuzzel
    hyprsunset
    hyprpicker
    swaynotificationcenter  # swaync
    pulseaudio
    rofi
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

# List services that you want to enable:

# Enable the OpenSSH daemon.
# services.openssh.enable = true;

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
}

  # swapDevices = [
  #   {
  #     device = "/var/swap";   # caminho do swapfile
  #     size = 4096;            # 4 GB de fallback
  #     priority = 10;          # usado só depois do ZRAM
  #   }
  # ];
  #
  # zramSwap = {
  #   enable = true;
  #   memoryPercent = 50; # 100% da RAM = 16GB zram
  #   priority = 100;      # ZRAM recebe prioridade absoluta
  # };
