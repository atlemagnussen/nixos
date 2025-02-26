{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [  
    nodejs
    dotnet-sdk
    dotnet-sdk_9
    dotnet-runtime
    dotnet-runtime_9
  ];
}
