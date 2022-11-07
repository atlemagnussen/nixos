{ config, pkgs, ... }:

{
  imports =
  [
    ../../modules/sway.nix
  ];
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    services.xserver.layout = "no";
    # services.xserver.xkbOptions = "eurosign:e";
    services.xserver.libinput.enable = true;
    sound.enable = true;
    hardware.pulseaudio.enable = true;
  }
}