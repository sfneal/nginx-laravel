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
    rm /etc/nginx/conf.d/app.conf
fi

python3 /sites-scripts/certbot.py --domains "${domain}"

# Start Nginx service
nginx -g "daemon off;"