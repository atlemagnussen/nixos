#!/usr/bin/env bash
echo "pgback rest"
whoami

cat /mnt/pgbackrest.conf

gosu postgres pgbackrest --config=/mnt/pgbackrest.conf --stanza=main --log-level-console=info restore

#pgbackrest --config=/mnt/pgbackrest.conf --stanza=main --log-level-console=info restore

echo "done"
