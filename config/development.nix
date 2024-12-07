{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [  
    nodejs
    deno
    dotnet-sdk
    dotnet-sdk_9
    dotnet-runtime
    dotnet-runtime_9
  ];
}
