#!/usr/bin/env bash

source=/mnt/md1/bak/postgres/
copysource=/mnt/md1/bak/postgres_copy/
destination=atle@192.168.1.2:/mnt/md1/Backup/postgres

echo "0. check folder $copysource"

if [ -d $copysource ]; then
  echo "0. Dir exists. Remove to get a clean copy"
  rm -rf $copysource
fi

echo "1. copy from $source to $copysource"
sudo cp -r $source $copysource

echo "2. change owner for $copysource"
sudo chown atle:users -R $copysource

echo "3. sync to $destination including symlinks"
rsync -vrcz --links --progress $copysource $destination