{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [  
    nodejs
    nodePackages_latest.npm
    dotnet-sdk
    dotnet-runtime
  ];
}