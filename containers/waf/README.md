# WAF

- [BunkerWeb](https://www.bunkerweb.io)

## Files

- [pod.yaml](pod.yaml) - BunkerWeb All-In-One Pod for podman kube play
- [pvc.yaml](pvc.yaml) - Persistent volume claim for /data

## Deploy with podman kube play

1. Apply the persistent volume claim first:

```bash
cd /Users/atle/dev/nix/containers/waf
podman kube play --replace pvc.yaml
```

2. Start the BunkerWeb pod:

```bash
cd /Users/atle/dev/nix/containers/waf
podman kube play --replace pod.yaml
```

3. Check logs:

```bash
podman pod ps
podman logs -f bunkerweb-aio-bunkerweb-aio
```

4. Access setup wizard:

- https://your-host/setup

## Port setup for rootless Podman

Rootless cannot bind privileged ports by default. BunkerWeb needs host ports 80 and 443 if it should terminate TLS directly.

Option A (recommended): allow unprivileged low ports on host

```bash
sudo sysctl net.ipv4.ip_unprivileged_port_start=1
echo 'net.ipv4.ip_unprivileged_port_start=1' | sudo tee /etc/sysctl.d/99-rootless-lowports.conf
sudo sysctl --system
```

Option B: use high host ports (no sysctl change)

- Change [pod.yaml](pod.yaml) hostPort values:
	- 80 -> 8080
	- 443 -> 8443 (TCP)
	- 443 -> 8443 (UDP)
- Then access via https://your-host:8443

## Teardown

```bash
cd /Users/atle/dev/nix/containers/waf
podman kube down pod.yaml
podman kube down pvc.yaml
```

Note: running down pvc.yaml removes the named volume created by the claim. Skip that command if you want to keep data.