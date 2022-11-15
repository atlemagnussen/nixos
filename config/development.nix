{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [  
    nodejs
    dotnet-sdk
    dotnet-runtime
  ];
}