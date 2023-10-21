{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [  
    nodejs
    deno
    dotnet-sdk
    dotnet-runtime
    azure-functions-core-tools
  ];
}