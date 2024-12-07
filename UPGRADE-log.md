# Upgrades

Started with adding nvidia driver stuff

## Upgraded to 24.11

- The option definition `sound' in `/home/atle/nixos-config/config/desktop.nix' no longer has any effect; please remove it.
The option was heavily overloaded and can be removed from most configurations.

- The option definition `programs.gnupg.agent.pinentryFlavor' in `/home/atle/nixos-config/config/terminal.nix' no longer has any effect; please remove it.
Use programs.gnupg.agent.pinentryPackage instead

- You must configure `hardware.nvidia.open` on NVIDIA driver versions >= 560.
It is suggested to use the open source kernel modules on Turing or later GPUs (RTX series, GTX 16xx), and the closed source modules otherwise.

also removed azure-functions-core-tools because outdated