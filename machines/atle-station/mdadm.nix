{ config, pkgs, lib, ... }:
let
  mdadmconf = ''
    ARRAY /dev/md/atle-pc:0 metadata=1.2 name=atle-pc:0 UUID=69e33663:d1a088c1:ac0a7739:1d05b0d7
    ARRAY /dev/md/atle-station:1 metadata=1.2 name=atle-pc:0 UUID=FIXTHIS
  '';
in
{
  systemd.services.mdadm-monitor = {
    description = "Monitor RAID disks";
    wantedBy = [ "multi-user.target" ];
    script = "${pkgs.mdadm}/bin/mdadm --monitor /dev/md/atle-pc:0 /dev/md/atle-station:1";
  };
  environment.etc.mdadmconf = {
    target = "mdadm/mdadm.conf";
    text = ''
      MAILADDR atlemagnussen@outlook.com
      MAILFROM atlemagnussen@gmail.com
      ${mdadmconf}
    '';
  };
  boot.initrd.services.swraid.mdadmConf = mdadmconf;

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
