#!/usr/bin/env bash

replace_domain --domain ${domain} --conf-file /etc/nginx/conf.d/default.conf

if [ ${aws_s3} -gt 0 ]
then
    # Configure AWS creds
    sh /scripts/aws-credentials.sh

    # Download certs from AWS S3
    awss3 sync --bucket ${aws_s3_bucket} \
        --local_path /etc/letsencrypt/live/ \
        --remote_path /live/ \
        --remote_source
else
    # Make directory for dummy certificates
    # Create dummy certificate for ${domain}
    echo "Creating dummy certificate for ${domain}"
    mkdir -m 777 -p /etc/letsencrypt/live/${domain}/ \
        && openssl req -x509 -nodes -newkey rsa:1024 -days 1 \
            -keyout "/etc/letsencrypt/live/${domain}/privkey.pem" \
            -out "/etc/letsencrypt/live/${domain}/fullchain.pem" \
            -subj "/CN=localhost"
fi

# Start Nginx service
nginx -g "daemon off;"