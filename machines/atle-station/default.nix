
{ config, pkgs, ... }:

{
  imports =
  [
    ../../config/global.nix
    ../../config/udev.nix
    ../../config/terminal.nix
    ../../config/home-manager.nix
    ../../modules/neovim/with-user-config.nix
    ../../config/desktop.nix
    ./hardware-configuration.nix
    ./network-configuration.nix
    ./mdadm.nix
    ./systemd.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    firefox
    chromium
    virt-manager
    virtiofsd
    gimp3-with-plugins
    gimpPlugins.gmic
  ];

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [22 2256];
    allowSFTP = true;
    settings.X11Forwarding = true;
  };

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  virtualisation.containers.enable = true;
  virtualisation = {
    docker = {
      enable = true;
    };
    libvirtd.enable = true;
    podman = {
      enable = true;
      dockerCompat = false;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  users.users.atle = {
    extraGroups = [ "docker" "libvirtd" ];
  };

  programs.dconf = {
    enable = true;
  };
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11";

}

