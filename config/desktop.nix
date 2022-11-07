{ config, pkgs, ... }:

{
  imports =
  [
    ../modules/sway.nix
  ];

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "no";
    displayManager.lightdm.enable = false;
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;
    desktopManager.plasma5.enable = true;
    #displayManager.sddm.enable = true;
    # xkbOptions = "eurosign:e";
    libinput.enable = false;
  };

  sound.enable = false;
  hardware.pulseaudio.enable = false;
}