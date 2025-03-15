#!/usr/bin/env bash
echo "pgback rest"
sleep 2
# pgbackrest --config=/mnt/pgbackrest.conf --stanza=main --log-level-console=info restore
echo "done"
exit 0