{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [  
    nodejs
    deno
    dotnet-sdk
    dotnet-runtime
  ];
}