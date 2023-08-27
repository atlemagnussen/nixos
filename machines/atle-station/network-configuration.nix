# atle-station netwok
{ config, pkgs, lib, ... }:
let
  bridge_interface = "br0";
  lan_interface = "enp4s0";
in
{
  networking = {
    hostName = "atle-station";
    networkmanager.enable = true;
    useDHCP = false #lib.mkDefault true;
    firewall.enable = false;
    interfaces = {
      ${lan_interface}.useDHCP = false;
      ${bridge_interface}.useDHCP = true;
    };
    bridges = {
      ${bridge_interface} = {
        interfaces = [
          lan_interface
        ];
      };
    };
  };
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  
  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  
  # networking.interfaces.enp4s0.useDHCP = lib.mkDefault true;

  
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.

  #networking.bridges = {
  #  "br0" = {
  #    interfaces = [ "enp4s0" ];
  #  };
  #};
}
