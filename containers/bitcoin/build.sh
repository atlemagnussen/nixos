#!/usr/bin/env bash
git pull
docker rmi atlmag/bitcoin
docker rmi atlmag/bitcoin:28.1
docker build -f Dockerfile_bitcoind --tag atlmag/bitcoin:latest --tag atlmag/bitcoin:28.1 .