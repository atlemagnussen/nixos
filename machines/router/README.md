# router not yet configured with nix

this is just the bind9 setup following [this guide](https://www.digitalocean.com/community/tutorials/how-to-configure-bind-as-a-private-network-dns-server-on-ubuntu-14-04)

but skipping the 2nd dns server

## commands to verify setup
```sh
sudo named-checkconf
```

```sh
sudo named-checkzone atle.guru /etc/bind/zones/db.atle.guru
```

```sh
sudo named-checkzone 1.168.192.in-addr.arpa /etc/bind/zones/db.192.168.1
```