# NixOS Configuration for AI Product Search Pod
# Add this to your NixOS configuration or use as a module

{ config, pkgs, ... }:

{
  # Enable Podman (Docker alternative)
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true;
  virtualisation.podman.dockerSocket.enable = true;

  # Enable GPU support for Ollama (if you have Nvidia GPU)
  hardware.nvidia.open = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidia_x11;

  # Create systemd service for AI Search pod
  systemd.services.ai-search-pod = {
    description = "AI Product Search Pod";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    
    serviceConfig = {
      Type = "simple";
      User = "root";
      WorkingDirectory = "/data/code/nixos/ai/search";
      ExecStart = "${pkgs.podman}/bin/podman-compose up";
      ExecStop = "${pkgs.podman}/bin/podman-compose down";
      Restart = "on-failure";
      RestartSec = "10s";
      StandardOutput = "journal";
      StandardError = "journal";
    };

    wantedBy = [ "multi-user.target" ];
  };

  # Environment for building and running the service
  environment.systemPackages = with pkgs; [
    podman
    podman-compose
    docker
    curl
    wget
  ];

  # Open firewall ports if needed
  networking.firewall.allowedTCPPorts = [ 8000 11434 8080 ];

  # Create persistent storage directories
  system.activationScripts = {
    ai-search-storage = ''
      mkdir -p /data/code/nixos/ai/search/db
      chmod 755 /data/code/nixos/ai/search/db
    '';
  };
}
