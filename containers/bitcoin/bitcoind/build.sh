#!/usr/bin/env bash
set -euo pipefail
VERSION=${1:-32.1}
git pull
podman build --build-arg version="$VERSION" \
  --tag atlmag/bitcoin:latest --tag atlmag/bitcoin:"$VERSION" .
