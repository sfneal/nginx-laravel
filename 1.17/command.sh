#!/usr/bin/env bash

replace_domain --domain ${domain} --conf-file /etc/nginx/conf.d/default.conf

# Make directory for dummy certificates
# Create dummy certificate for ${domain}
echo "Creating dummy certificate for ${domain}"
mkdir -m 777 -p /etc/letsencrypt/live/${domain}/ \
    && openssl req -x509 -nodes -newkey rsa:2048 -days 1 \
        -keyout "/etc/letsencrypt/live/${domain}/privkey.pem" \
        -out "/etc/letsencrypt/live/${domain}/fullchain.pem" \
        -subj "/CN=localhost"

# Start Nginx service
nginx -g "daemon off;"