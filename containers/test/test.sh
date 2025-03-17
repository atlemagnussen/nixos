
podman volume create \
      -o device=/home/atle/nix/containers/test/data \
      -o=o=bind \
      mycustomvol

podman run --name test-vol -v mycustomvol:/mnt:z -it debian:bookworm-slim

