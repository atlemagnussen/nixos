{ config, pkgs, lib, ... }:
let
  mdadmconf = ''
    ARRAY /dev/md/md2g metadata=1.2 name=atle-pc:0 UUID=69e33663:d1a088c1:ac0a7739:1d05b0d7
    ARRAY /dev/md/md8g metadata=1.2 name=atle-station:1 UUID=e323b6d5:c29ed9bd:5f752e08:50e69e21
  '';
in
{
  systemd.services.mdadm-monitor = {
    description = "Monitor RAID disks";
    wantedBy = [ "multi-user.target" ];
    script = "${pkgs.mdadm}/bin/mdadm --monitor /dev/md/md2g";
  };
  environment.etc.mdadmconf = {
    target = "mdadm/mdadm.conf";
    text = ''
      MAILADDR atlemagnussen@outlook.com
      MAILFROM atlemagnussen@gmail.com
      ${mdadmconf}
    '';
  };

  boot.swraid.enable = true;
  boot.swraid.mdadmConf = mdadmconf;

  fileSystems = {
    "/mnt/md0" = {
      device = "/dev/md/md2g";
      fsType = "ext4";
    };
    "/mnt/md1" = {
      device = "/dev/md/md8g";
      fsType = "ext4";
    };
  };
  # boot.initrd.mdadmConf = mdadmconf;
}
