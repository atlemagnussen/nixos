#!/usr/bin/env sh

docker run -d --env-file .env.prod \
 --user 1000:100 \
 -p 8000:5000 --name atle-webdir-listing \
 --mount source=datavolume,target=/data \
 --restart unless-stopped \
web-dir-listing