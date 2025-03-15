#!/usr/bin/env bash
podman rmi atlmag/postgres:17
podman build --tag atlmag/postgres:17 .

podman rmi atlmag/pgbackrest:latest
podman build -f ContainerfilePgBackRest --tag atlmag/pgbackrest:latest .

podman run--name pgbackrest-atle \
-v /mnt/md0/databases/postgres:/var/lib/postgresql/data \
-v /mnt/md1/bak/postgres:/mnt \
atlmag/pgbackrest:latest
