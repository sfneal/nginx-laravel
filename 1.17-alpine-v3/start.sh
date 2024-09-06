#!/usr/bin/env bash

# Replace $DOMAIN placeholder in default.conf with real domain
replace_domain --domain ${domain} --conf-file /etc/nginx/conf.d/default.conf

# Make directory for live SSL certs
mkdir -m 777 -p /etc/letsencrypt/live/${domain}/
mkdir -m 777 -p /etc/letsencrypt/renewal/${domain}/

# Create dummy certificate for ${domain}
echo "Creating dummy certificate for ${domain}"
openssl req -x509 -nodes -newkey rsa:2048 -days 1 \
    -keyout "/etc/letsencrypt/live/${domain}/privkey.pem" \
    -out "/etc/letsencrypt/live/${domain}/fullchain.pem" \
    -subj "/CN=localhost"

if [ ${aws_s3} -gt 0 ]
then
    # Configure AWS creds
    sh /scripts/aws-credentials.sh

    # Pull certs from AWS S3
    # if the certs don't exist, dummy certs should remain?
    echo "Pulling certs from AWS S3"
    awss3 download --bucket ${aws_s3_bucket} \
        --local_path /etc/letsencrypt/live/${domain}/ \
        --remote_path live/${domain}/ \
        --recursive
    awss3 download --bucket ${aws_s3_bucket} \
        --local_path /etc/letsencrypt/renewal/${domain}.conf \
        --remote_path renewal/${domain}.conf
fi

# Start Nginx service
nginx -g "daemon off;"