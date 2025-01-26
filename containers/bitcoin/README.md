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
docker exec -it bitcoin-bitcoind-1 bash
```

## bitcoin-cli

```sh
docker exec -it bitcoin-bitcoind-1 bitcoin-cli getpeerinfo
docker exec -it bitcoin-bitcoind-1 bitcoin-cli getblockchaininfo
docker exec -it bitcoin-bitcoind-1 bitcoin-cli getnetworkinfo
docker exec -it bitcoin-bitcoind-1 bitcoin-cli getwalletinfo

docker exec -it bitcoin-bitcoind-1 bitcoin-cli loadwallet wallet.dat
```
