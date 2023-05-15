#!/bin/bash

set -e

echo "Checking for dhparams.pem"
if [ ! -f "/vol/proxy/ssl-dhparams.pem" ]; then
  echo "dhparams.pem does not exist - creating it"
  # same volume location is in default.ssl.conf.tpl file
  openssl dhparam -out /vol/proxy/ssl-dhparams.pem 2048
fi

# Avoid replacing these with envsubst (environment variable substitute)
export host=\$host
export request_uri=\$request_uri

echo "Checking for fullchain.pem"
if [ ! -f "/etc/letsencrypt/live/${DOMAIN}/fullchain.pem" ]; then
  # This block will be ran first time only to get the certificate
  echo "No SSL cert, enabling HTTP only..."
  envsubst < /etc/nginx/default.conf.tpl > /etc/nginx/conf.d/default.conf
else
  echo "SSL cert exists, enabling HTTPS..."
  envsubst < /etc/nginx/default-ssl.conf.tpl > /etc/nginx/conf.d/default.conf
fi
# Starts nginx server in the foreground
nginx -g 'daemon off;'