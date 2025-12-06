# Cloudflare DNS

https://certbot-dns-cloudflare.readthedocs.io/en/stable/

sudo certbot certonly --dns-cloudflare \
  --dns-cloudflare-credentials /path/to/cloudflare.ini \
  -d yourdomain.com \
  -d *.yourdomain.com \
  --preferred-challenges dns-01