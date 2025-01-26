# BTC container

## verify

wget https://bitcoincore.org/bin/bitcoin-core-28.1/bitcoin-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz
wget https://bitcoincore.org/bin/bitcoin-core-28.1/SHA256SUMS
wget https://bitcoincore.org/bin/bitcoin-core-28.1/SHA256SUMS.asc
sha256sum --ignore-missing --check SHA256SUMS

## build 
docker build -f Dockerfile_bitcoind --tag atlmag/bitcoin:latest --tag atlmag/bitcoin:28.1 .