#!/usr/bin/env bash
echo "pgback rest"
pgbackrest --config=/mnt/pgbackrest.conf --stanza=main --log-level-console=info restore
echo "done"
exit 0