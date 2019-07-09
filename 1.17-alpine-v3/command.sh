#!/usr/bin/env bash

replace_domain --domain ${domain} --conf-file /etc/nginx/conf.d/default.conf

# Make directory for dummy certificates
# Create dummy certificate for ${domain}
echo "Creating dummy certificate for ${domain}"
mkdir -m 777 -p /etc/letsencrypt/live/${domain}/ \
    && openssl req -x509 -nodes -newkey rsa:1024 -days 1 \
        -keyout "/etc/letsencrypt/live/${domain}/privkey.pem" \
        -out "/etc/letsencrypt/live/${domain}/fullchain.pem" \
        -subj "/CN=localhost"

# Check if aws_s3 is enabled
if [ ${aws_s3} -gt 0 ]
then
    sh /scripts/aws-credentials.sh
    awss3 --bucket hpa-ssl-certs sync --local_path awsutils/s3
fi

# Start Nginx service
nginx -g "daemon off;"