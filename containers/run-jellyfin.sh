docker run -d \
  --user 1000:100 \
 -p 8096:8096 --name jellyfin-atle \
 -v /mnt/md1/config/jellyfin:/config \
 -v /mnt/ssd1/cache:/cache \
 --mount type=bind,source=/mnt/md1/Media,target=/media \
 --restart=unless-stopped \
 jellyfin/jellyfin