{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [  
    nodejs
    deno
    dotnet-sdk
    dotnet-sdk_8
    dotnet-runtime
    dotnet-runtime_8
    azure-functions-core-tools
  ];
}
