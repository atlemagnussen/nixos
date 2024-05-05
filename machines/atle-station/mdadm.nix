{ config, pkgs, lib, ... }:
let
  mdadmconf = ''
    ARRAY /dev/md/atle-station:1 metadata=1.2 name=atle-station:1 UUID=067378a8:3b31e8ab:42cbe7a3:e15a4a84
    ARRAY /dev/md/atle-pc:0 metadata=1.2 name=atle-pc:0 UUID=69e33663:d1a088c1:ac0a7739:1d05b0d7
  '';
in
{
  systemd.services.mdadm-monitor = {
    description = "Monitor RAID disks";
    wantedBy = [ "multi-user.target" ];
    script = "${pkgs.mdadm}/bin/mdadm --monitor /dev/md/atle-pc:0";
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
      device = "/dev/md/atle-pc:0";
      fsType = "ext4";
    };
    "/mnt/md1" = {
      device = "/dev/md/atle-station:1";
      fsType = "ext4";
    };
  };
  # boot.initrd.mdadmConf = mdadmconf;
}
