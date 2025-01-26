#!/usr/bin/env bash

docker run -it \
  --user 1006:1001 \
 -p 8333:8333 --name bitcoind-atle \
 --mount type=bind,source=/mnt/ssd2/blockchain/bitcoin,target=/home/bitcoin/.bitcoin \
 atlmag/bitcoin bash