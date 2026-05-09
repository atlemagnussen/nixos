Option 1 (best): Use a named Podman volume

Let Podman manage ownership/labels.
This is the safest for rootless pods and easiest to recreate.
Steps:

Remove old pod if still present.
Remove and recreate the volume.
Start pod again.
Commands:

podman pod rm -f wafPod
podman volume rm bw-data
podman volume create bw-data
podman kube play pod.yaml

Why this works:

Your pod mounts the claim bw-data to /data in pod.yaml:1.
Podman-created volumes usually come up writable for the container process without manual chown.
Option 2: Bind mount a host folder (if you want direct host access)

Then you must set ownership and SELinux label handling as needed.
Commands:

mkdir -p /path/to/bw-data
podman run --rm --entrypoint sh bunkerity/bunkerweb-all-in-one:1.6.9 -lc 'id -u; id -g'
sudo chown -R <UID>:<GID> /path/to/bw-data
chmod 750 /path/to/bw-data

Replace <UID>:<GID> with what the image reports.

If your system uses SELinux, mount with label:

Add :Z to the bind mount option in your pod spec.
Quick verification after start:

podman ps --filter pod=wafPod
podman exec <container-id> sh -lc 'touch /data/.perm-test && ls -l /data/.perm-test'
If that file is created, permissions are correct.

Most likely for your case:

Recreate named volume bw-data and redeploy.
Avoid manual host folder permissions unless you specifically need host-side browsing/editing.