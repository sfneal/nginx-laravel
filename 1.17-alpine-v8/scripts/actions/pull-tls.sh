#!/usr/bin/env bash

# Create directory
mkdir /etc/nginx

# Pull TLS params from GitHub
curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/options-ssl-nginx.conf > "/etc/nginx/options-ssl-nginx.conf"
curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot/ssl-dhparams.pem > "/etc/nginx/ssl-dhparams.pem"