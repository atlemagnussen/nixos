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


 #--mount type=bind,source=/mnt/ssd2/blockchain/bitcoin,target=/home/bitcoin/.bitcoin \