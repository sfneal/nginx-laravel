#!/usr/bin/env bash

if [[ ${aws_s3} -gt 0 ]]
then
    # Configure AWS creds
    sh /scripts/aws-credentials.sh
fi

# Conditionally include app.conf with API exposure
if [[ ${api_enabled} -gt 0 ]]
then
    echo "API serving is enabled..."
else
    echo "API serving is disabled..."
    rm /etc/nginx/conf.d/api.conf
fi

# Download/create SSL certs for each domain
for d in ${domain}; do
    sh /sites-scripts/certify.sh ${d}
done

# Start Nginx service
nginx -g "daemon off;"