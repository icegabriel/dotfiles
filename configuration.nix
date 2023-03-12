# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "nixos"; # Define your hostname.

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

  # Enable experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable i3 Desktop Environment
  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };
   
    displayManager = {
	lightdm.enable = true;
        defaultSession = "none+i3";
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
    	rofi
        dunst
        dmenu
	xss-lock
        i3lock
	i3blocks
     ];
    };
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gabrielfiuza = {
    isNormalUser = true;
    description = "Gabriel Fiúza";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  # Configure home manager
  home-manager.users.gabrielfiuza = { pkgs, ... }: {

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Enable MPD
    services.mpd = {
      enable = true;
      musicDirectory = "/home/gabrielfiuza/Music";

      extraConfig = ''
        audio_output {
          type            "pipewire"
          name            "PipeWire Sound Server"
        }

        audio_output {
          type		"fifo"
          name		"FIFO"
          path		"/home/gabrielfiuza/.cache/mpd.fifo"
          format	"44100:16:2"
        }
      '';
    };

    # Configure zsh
    programs.zsh = {
      enable = true;
      dotDir = ".config/zsh";
      history.path = "/home/gabrielfiuza/.config/zsh/zsh_history";
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      initExtra = ''
        bindkey '^ ' autosuggest-accept
      '';

      oh-my-zsh.enable = true;
      oh-my-zsh.plugins = [ "git" ];
      oh-my-zsh.theme = "robbyrussell";
    };

    home = {
      packages = with pkgs; [];

      stateVersion = "22.11";
    };
  };

  # Define Session Variables
  environment.sessionVariables = {
    EDITOR = "nvim";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    neovim
    ranger
    alacritty
    btop
    zip
    unzip
    distrobox
    mpv
    git
    pulseaudio
    cava
    feh
    mpc-cli
    vimpc
    gettext
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # NVIDIA Drivers 
  hardware.opengl.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.modesetting.enable = true;

  # Enable Redshift
  location.latitude = -19.472858;
  location.longitude = -45.603113;
  services.redshift = {
    enable = true;
    temperature = {
      day = 3700;
      night = 2000;
    };
  };

  # Enable Picom
  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;
    inactiveOpacity = 0.6;
    activeOpacity = 1;

    opacityRules = [
      "100:class_g = 'Rofi'"
    ];

    settings = {
      blur = {
      	method = "dual_kawase";
	size = 12;
      };
    };
  };

  # Enable cron service
  services.cron = {
    enable = true;
    systemCronJobs = [
      "* * * * *	gabrielfiuza	( DISPLAY=:0 feh --bg-center --randomize /home/gabrielfiuza/Pictures/Wallpapers/* )"
      "* * * * *	gabrielfiuza	( sleep 10 ; DISPLAY=:0 feh --bg-center --randomize /home/gabrielfiuza/Pictures/Wallpapers/* )"
      "* * * * *	gabrielfiuza	( sleep 20 ; DISPLAY=:0 feh --bg-center --randomize /home/gabrielfiuza/Pictures/Wallpapers/* )"
      "* * * * *	gabrielfiuza	( sleep 30 ; DISPLAY=:0 feh --bg-center --randomize /home/gabrielfiuza/Pictures/Wallpapers/* )"
      "* * * * *	gabrielfiuza	( sleep 40 ; DISPLAY=:0 feh --bg-center --randomize /home/gabrielfiuza/Pictures/Wallpapers/* )"
      "* * * * *	gabrielfiuza	( sleep 50 ; DISPLAY=:0 feh --bg-center --randomize /home/gabrielfiuza/Pictures/Wallpapers/* )"
    ];
  };

  # Podman Config
  virtualisation = {
    podman = {
      enable = true;
      enableNvidia = true;
      dockerCompat = true;
      defaultNetwork.dnsname.enable = true;
    };
  };

  # Enable Flatpak
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  programs.dconf.enable = true;
  services.flatpak.enable = true;

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
  system.stateVersion = "22.11"; # Did you read the comment?
}
