# mail

docker volume create maddydata

docker volume create maddydata --opt type=none --opt device=~/config/email --opt o=bind


docker run \
  --name maddy -d \
  -v maddydata:/data \
  -p 143:143 \
  -p 587:587 \
  -p 993:993 \
  foxcpp/maddy:0.8

docker run --rm -it -v maddydata:/data foxcpp/maddy:0.8 creds create atle@atle.guru
docker run --rm -it -v maddydata:/data foxcpp/maddy:0.8 imap-acct create atle@atle.guru

docker run --rm -it -v maddydata:/data foxcpp/maddy:0.8 creds create hello@atle.guru
docker run --rm -it -v maddydata:/data foxcpp/maddy:0.8 imap-acct create hello@atle.guru
