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
    displayManager.sddm.enable = true;
    # xkbOptions = "eurosign:e";
    libinput.enable = false;
  };

  sound.enable = false;
  hardware.pulseaudio.enable = false;
}