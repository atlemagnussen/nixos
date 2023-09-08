# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/a83045d7-1a04-4b66-aea6-bcb20e1fd224";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/2617-7416";
      fsType = "vfat";
    };
  
  fileSystems."/mnt/ssd1" =
    { device = "/dev/disk/by-uuid/f5d240d5-a487-4e1d-8879-ea2156e5307f";
      fsType = "ext4";
    };

  swapDevices = [
    { device = "/dev/disk/by-uuid/afa3deb2-fcb9-4d9f-b18c-b713c0081b6f"; }
  ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
