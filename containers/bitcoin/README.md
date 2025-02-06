# BTC container

## verify

```sh
wget https://bitcoincore.org/bin/bitcoin-core-28.1/bitcoin-28.1-x86_64-linux-gnu.tar.gz
wget https://bitcoincore.org/bin/bitcoin-core-28.1/SHA256SUMS
wget https://bitcoincore.org/bin/bitcoin-core-28.1/SHA256SUMS.asc
sha256sum --ignore-missing --check SHA256SUMS

```
## build

```sh
docker build -f Dockerfile_bitcoind --tag atlmag/bitcoin:latest --tag atlmag/bitcoin:28.1 .
```

## run

```sh
docker compose up -d
```

## inspect
```sh
docker exec -it -u bitcoin bitcoin-bitcoind-1 bash
docker exec -it bitcoin-lnd-1 bash
```

~/.lnd/data/chain/bitcoin/mainnet

## bitcoin-cli

```sh
docker exec -it -u bitcoin bitcoin-bitcoind-1 bitcoin-cli -getinfo
docker exec -it -u bitcoin bitcoin-bitcoind-1 bitcoin-cli -getpeerinfo
docker exec -it -u bitcoin bitcoin-bitcoind-1 bitcoin-cli -getblockchaininfo
docker exec -it -u bitcoin bitcoin-bitcoind-1 bitcoin-cli -getnetworkinfo
docker exec -it -u bitcoin bitcoin-bitcoind-1 bitcoin-cli -getwalletinfo

bitcoin-cli -rpcconnect=192.168.1.203 -rpcport=8332 -rpcuser=<user_name> -rpcpassword=<password> -getinfo

docker exec -it bitcoin-bitcoind-1 bitcoin-cli loadwallet wallet.dat
```

moneyprintergobrrr

## TOR

https://github.com/lightningnetwork/lnd/blob/master/docs/configuring_tor.md

https://docs.megalithic.me/set-up-a-lightning-node/setup-tor-with-docker/