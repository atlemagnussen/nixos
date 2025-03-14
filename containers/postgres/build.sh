#!/usr/bin/env bash
podman rmi atlmag/postgres:17
podman build --tag atlmag/postgres:17 .

podman build -f ContainerfilePgBackRest --tag atlmag/pgbackrest:latest .