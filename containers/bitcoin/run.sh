#!/usr/bin/env bash

docker run -it \
 -p 8333:8333 --name bitcoind-atle \
 -e UID=1006 \
 -e GID=1001 \
 -v /mnt/ssd2/blockchain/bitcoin:/home/bitcoin/.bitcoin \
 atlmag/bitcoin


docker run -it \
 -p 8333:8333 --name bitcoind-bash \
 -e UID=1006 \
 -e GID=1001 \
 -v /mnt/ssd2/blockchain/bitcoin:/home/bitcoin/.bitcoin \
 atlmag/bitcoin bash


docker run -d \
 -p 9050:9050 -p 9051:9051 --name tor-bridge \
 --mount type=bind,source=/home/atle/tor/config,target=/home/tor/config \
 atlmag/tor-bridge
 #--mount type=bind,source=/mnt/ssd2/blockchain/bitcoin,target=/home/bitcoin/.bitcoin \