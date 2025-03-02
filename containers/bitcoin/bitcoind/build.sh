#!/usr/bin/env bash
git pull
podman rmi atlmag/bitcoin
podman rmi atlmag/bitcoin:28.1
podman build --tag atlmag/bitcoin:latest --tag atlmag/bitcoin:28.1 .
