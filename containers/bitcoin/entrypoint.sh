#!/usr/bin/env bash

set -e

if [ -n "${UID+x}" ] && [ "${UID}" != "0" ]; then
  usermod -u "$UID" bitcoin
fi

if [ -n "${GID+x}" ] && [ "${GID}" != "0" ]; then
  groupmod -g "$GID" bitcoin
fi

echo "$0: assuming uid:gid for bitcoin:bitcoin of $(id -u bitcoin):$(id -g bitcoin)"

if [ "$(echo "$1" | cut -c1)" = "-" ]; then
  echo "$0: assuming arguments for bitcoind"

  set -- bitcoind "$@"
fi

if [ "$(echo "$1" | cut -c1)" = "-" ] || [ "$1" = "bitcoind" ]; then
  # Fix permissions for home dir.
  bitcoinhome="$(getent passwd bitcoin | cut -d: -f6)"
  echo "$0: Fix permissions for home dir: $bitcoinhome"
  chown -R bitcoin:bitcoin "$bitcoinhome"

  # Fix permissions for bitcoin data dir.
  echo "$0: Fixing permissions for $BITCOIN_DATA"
  chown -R bitcoin:bitcoin "$BITCOIN_DATA"
  chmod 770 "$BITCOIN_DATA"

  #echo "$0: setting data directory to $BITCOIN_DATA"
  #set -- "$@" -datadir="$BITCOIN_DATA"
fi

if [ "$1" = "bitcoind" ] || [ "$1" = "bitcoin-cli" ] || [ "$1" = "bitcoin-tx" ]; then
  echo
  exec gosu bitcoin "$@"
fi

echo
exec "$@"