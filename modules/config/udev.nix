{ config, pkgs, ... }:

{
  services = {
    udev.extraRules = ''
      # For Kaleidoscope/Keyboardio
      # this udev file should be used with udev 188 and newer
      ACTION!="add|change", GOTO="u2f_end"
      # Yubico YubiKey
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0113|0114|0115|0116|0120|0121|0200|0402|0403|0406|0407|0410", TAG+="uaccess", GROUP="plugdev", MODE="0660"
      # Happlink (formerly Plug-Up) Security KEY
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="f1d0", TAG+="uaccess", GROUP="plugdev", MODE="0660"
      # Neowave Keydo and Keydo AES
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1e0d", ATTRS{idProduct}=="f1d0|f1ae", TAG+="uaccess", GROUP="plugdev", MODE="0660"
      # HyperSecu HyperFIDO
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="096e|2ccf", ATTRS{idProduct}=="0880", TAG+="uaccess", GROUP="plugdev", MODE="0660"
      # Feitian ePass FIDO, BioPass FIDO2
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="096e", ATTRS{idProduct}=="0850|0852|0853|0854|0856|0858|085a|085b|085d|0866|0867", TAG+="uaccess", GROUP="plugdev", MODE="0660"
      # JaCarta U2F
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="24dc", ATTRS{idProduct}=="0101|0501", TAG+="uaccess", GROUP="plugdev", MODE="0660"
      # U2F Zero
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="8acf", TAG+="uaccess", GROUP="plugdev", MODE="0660"
      # VASCO SecureClick
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1a44", ATTRS{idProduct}=="00bb", TAG+="uaccess", GROUP="plugdev", MODE="0660"
      # Bluink Key
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="2abe", ATTRS{idProduct}=="1002", TAG+="uaccess", GROUP="plugdev", MODE="0660"
      # Thetis Key
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1ea8", ATTRS{idProduct}=="f025", TAG+="uaccess", GROUP="plugdev", MODE="0660"
      # Nitrokey FIDO U2F, Nitrokey FIDO2, Safetech SafeKey
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="20a0", ATTRS{idProduct}=="4287|42b1|42b3", TAG+="uaccess", GROUP="plugdev", MODE="0660"
      # Google Titan U2F
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="18d1", ATTRS{idProduct}=="5026", TAG+="uaccess", GROUP="plugdev", MODE="0660"
      # Tomu board + chopstx U2F + SoloKeys
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="cdab|a2ca", TAG+="uaccess", GROUP="plugdev", MODE="0660"
      # SoloKeys
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="5070|50b0", TAG+="uaccess", GROUP="plugdev", MODE="0660"
      # Trezor
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="534c", ATTRS{idProduct}=="0001", TAG+="uaccess", GROUP="plugdev", MODE="0660"
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="53c1", TAG+="uaccess", GROUP="plugdev", MODE="0660"
      # Infineon FIDO
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="058b", ATTRS{idProduct}=="022d", TAG+="uaccess", GROUP="plugdev", MODE="0660"
      # Ledger Blue, Nano S and Nano X
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0000|0001|0004|0005|0015|1005|1015|4005|4015", TAG+="uaccess", GROUP="plugdev", MODE="0660"
      # Kensington VeriMark
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="06cb", ATTRS{idProduct}=="0088", TAG+="uaccess", GROUP="plugdev", MODE="0660"
      # Longmai mFIDO
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="4c4d", ATTRS{idProduct}=="f703", TAG+="uaccess", GROUP="plugdev", MODE="0660"
      # eWBM FIDO2 - Goldengate 310, 320, 500, 450
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="311f", ATTRS{idProduct}=="4a1a|4c2a|5c2f|f47c", TAG+="uaccess", GROUP="plugdev", MODE="0660"
      # OnlyKey (FIDO2 / U2F)
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="60fc", TAG+="uaccess", GROUP="plugdev", MODE="0660"
      # GoTrust Idem Key
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1fc9", ATTRS{idProduct}=="f143", TAG+="uaccess", GROUP="plugdev", MODE="0660"
      # ellipticSecure MIRKey
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="a2ac", TAG+="uaccess", GROUP="plugdev", MODE="0660"
      LABEL="u2f_end"
    '';
  };
}