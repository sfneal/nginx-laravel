#!/usr/bin/env bash

echo "Creating SSL certs for ${domain_current}..."

# Copy nginx config template
cp /sites-scripts/template.conf /etc/nginx/conf.d/${domain_current}.conf

# Replace $DOMAIN placeholder in default.conf with real domain_current
replace_domain_current --domain_current ${domain_current} --conf-file /etc/nginx/conf.d/${domain_current}.conf

# Make directory for live SSL certs
mkdir -m 777 -p /etc/letsencrypt/live/${domain_current}/
mkdir -m 777 -p /etc/letsencrypt/renewal/${domain_current}/

# Create dummy certificate for ${domain_current}
echo "Creating dummy certificate for ${domain_current}"
openssl req -x509 -nodes -newkey rsa:1024 -days 1 \
    -keyout "/etc/letsencrypt/live/${domain_current}/privkey.pem" \
    -out "/etc/letsencrypt/live/${domain_current}/fullchain.pem" \
    -subj "/CN=localhost"

if [[ ${aws_s3} -gt 0 ]]
then
    # Pull certs from AWS S3
    # if the certs don't exist, dummy certs should remain?
    echo "Pulling certs from AWS S3"
    awss3 download --bucket ${aws_s3_bucket} \
        --local_path /etc/letsencrypt/live/${domain_current}/ \
        --remote_path live/${domain_current}/ \
        --recursive
    awss3 download --bucket ${aws_s3_bucket} \
        --local_path /etc/letsencrypt/renewal/${domain_current}.conf \
        --remote_path renewal/${domain_current}.conf
fi