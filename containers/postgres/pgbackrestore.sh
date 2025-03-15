#!/usr/bin/env bash
echo "pgback rest"
sleep 2
# pgbackrest --config=/mnt/pgbackrest.conf --stanza=main --log-level-console=info restore
echo "done"
cat /mnt/pgbackrest.conf
exit 0