#!/usr/bin/env bash
echo "pgback rest"
whoami
sleep 2

cat /mnt/pgbackrest.conf

pgbackrest --config=/mnt/pgbackrest.conf --stanza=main --log-level-console=info restore
echo "done"
cat /mnt/pgbackrest.conf
exit 0
