{ config, pkgs, lib, ... }:
let
  dataDir = "/var/lib/rtorrent";
  downloadDir = "/mnt/heartstring/downloads/";
  openVpnPath = "/run/vpn.ovpn";
  floodServePort = 3001;
  rtorrentPort = 50000;
  dlnaTcpPort = 8200;
  dlnaUdpPort = 1900;
  container = {
    #this is NOT the ip of the hostmachine, just  a virtual address, can be any local address
    hostAdress = "192.168.100.10";
    localAdress = "192.168.100.11";
  };
in
{
  networking.nat.enable = true;
  networking.nat.internalInterfaces = ["ve-+"];
  networking.nat.externalInterface = "eth0";
  #extraCommands from https://github.com/NixOS/nixpkgs/issues/46975#issuecomment-424115361
  networking.nat.extraCommands = ''
    iptables -t nat -A nixos-nat-post -d  ${container.localAdress} -p tcp --dport ${toString floodServePort} -j SNAT --to-source ${container.hostAdress}
    iptables -t nat -A nixos-nat-post -d  ${container.localAdress} -p tcp --dport ${toString dlnaTcpPort} -j SNAT --to-source ${container.hostAdress}
    iptables -t nat -A nixos-nat-post -d  ${container.localAdress} -p udp --dport ${toString dlnaUdpPort} -j SNAT --to-source ${container.hostAdress}
  '';
  networking.nat.forwardPorts = [{
    sourcePort = floodServePort;
    proto = "tcp";
    destination = "${container.localAdress}:${toString floodServePort}";
  } {
    sourcePort = dlnaTcpPort;
    proto = "tcp";
    destination = "${container.localAdress}:${toString dlnaTcpPort}";
  } {
    sourcePort = dlnaUdpPort;
    proto = "udp";
    destination = "${container.localAdress}:${toString dlnaUdpPort}";
  }];
  # networking.firewall.allowedTCPPorts = [dlnaTcpPort  floodServePort ];
  # networking.firewall.allowedUDPPorts = [dlnaUdpPort];
  containers.mediaContainer = {
    privateNetwork = true;
    enableTun = true;
    autoStart = true;
    hostAddress = container.hostAdress;
    localAddress = container.localAdress;
    # forwardPorts = [{
    #   containerPort = floodServePort;
    #   protocol = "tcp";
    #   hostPort = floodServePort;
    # } {
    #   containerPort = dlnaTcpPort;
    #   protocol = "tcp";
    #   hostPort = dlnaTcpPort;
    # } {
    #   containerPort = dlnaUdpPort;
    #   protocol = "udp";
    #   hostPort = dlnaUdpPort;
    # }];
    bindMounts = {
      "${dataDir}" = {
        hostPath = dataDir;
        isReadOnly = false;
      };
      "${downloadDir}" = {
        hostPath = "${downloadDir}";
        isReadOnly = false;
      };
      "${openVpnPath}" = {
        hostPath = "${openVpnPath}";
        isReadOnly = true;
      };
    };
    config = {config, pkgs, lib, ...}:
    {
      services.openvpn = {
        servers.torrentVpn = {
          updateResolvConf = true;
          autoStart = true;
          config = "config ${openVpnPath}";
        };
      };
      #rtorrent module handles it own port-forward 
      networking.firewall.allowedTCPPorts = [dlnaTcpPort floodServePort];
      networking.firewall.allowedUDPPorts = [dlnaUdpPort];
      boot = {
        # this might also be needed on host machine
        kernel.sysctl = {
          "fs.inotify.max_user_watches" = "100000";
        };
      };
      services.minidlna = {
        enable = true;
        mediaDirs = [
          downloadDir
        ];
      };
      services.rtorrent = {
        user = "rtorrent";
        group = "minidlna";
        enable = true;
        port  = rtorrentPort;
        # rpcSocket = "/run/rtorrent/rpc.sock";
        openFirewall = true;
        downloadDir = downloadDir;
        dataDir = dataDir;
      };
      systemd.services.flood = {
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        description = "flood rtorrent frontend";
        serviceConfig = {
          Type = "simple";
          Restart = "always";
          ExecStart = "${pkgs.flood}/bin/flood -p ${toString floodServePort} -h 0.0.0.0 -d ${dataDir}";
          User="rtorrent";
        };
      };
      systemd.services.setPermissions = {
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        description = "sets permizzionr";
        serviceConfig = {
          Type = "simple";
          Restart = "on-failure";
          ExecStart = "${pkgs.coreutils}/bin/chown -R rtorrent:minidlna ${dataDir} ${downloadDir}";
          User="root";
        };
      };
    };
  };
}