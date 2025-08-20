# certbot

## Test

sudo certbot certonly --manual --preferred-challenges dns --test-cert

dont need this again


sudo certbot certonly --manual --preferred-challenges dns

*.atle.guru

Then use REST API to domeneshop


verify:

dig -t txt +short _acme-challenge.atle.guru

dig +nocmd +noall +answer @8.8.8.8 api.digilean.tools


Certificate is saved at: /etc/letsencrypt/live/atle.guru/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/atle.guru/privkey.pem
This certificate expires on 2025-03-23.
These files will be updated when the certificate renews.


verify nginx


sudo nginx -t
sudo nginx -s reload

# port scan
sudo nmap -sU -p 161 id.atle.guru
 snmpwalk -v 2c -c public id.atle.guru