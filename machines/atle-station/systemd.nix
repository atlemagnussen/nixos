
{ config, pkgs, ... }:

{
    systemd = {

        targets = {
            sleep = {
                enable = false;
                unitConfig.DefaultDependencies = "no";
                extraConfig = ''
                  AllowSuspend=no
                  AllowHibernation=no
                  AllowHybridSleep=no
                  AllowSuspendThenHibernate=no
                '';
            };
            suspend = {
                enable = false;
                unitConfig.DefaultDependencies = "no";
            };
            hibernate = {
                enable = false;
                unitConfig.DefaultDependencies = "no";
            };
            "hybrid-sleep" = {
                enable = false;
                unitConfig.DefaultDependencies = "no";
            };
        };
    };
}
# {
#   systemd.timers."hello-world" = {
#   wantedBy = [ "timers.target" ];
#     timerConfig = {
#       OnBootSec = "5m";
#       OnUnitActiveSec = "5m";
#       Unit = "hello-world.service";
#     };
# };

# systemd.services."hello-world" = {
#   script = ''
#     set -eu
#     ${pkgs.coreutils}/bin/echo "Hello World"
#   '';
#   serviceConfig = {
#     Type = "oneshot";
#     User = "root";
#   };
# };