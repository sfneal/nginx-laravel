#!/usr/bin/env bash

# Configure AWS creds
if [[ ${aws_s3} -gt 0 ]]
then
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

# Replace @VALIDATION_DOMAIN placeholder with env variable value
replace_domain --domain ${validation_domain} \
    --conf-file /etc/nginx/conf.d/default.conf \
    --placeholder '@VALIDATION_DOMAIN'

# Enable nginx configurations for each site
for d in ${domain}; do
    url_service_root=(${d//:/ })

    # @APP placeholder
    if [[ ! ${url_service_root[1]} ]] ;
    then
        # Assuming application service name is 'app' since its not provided
        url_service_root[1]='app'
    fi

    # @ROOT placeholder
    if [[ ! ${url_service_root[2]} ]] ;
    then
        # Assuming application service name is 'app' since its not provided
        url_service_root[2]='/var/www/public'
    fi

    # Run enable-conf.sh
    sh /sites-scripts/enable-conf.sh ${url_service_root[0]} ${url_service_root[1]} ${url_service_root[2]}

    # Enable SSL certs
    sh /sites-scripts/certify.sh ${url_service_root[0]}
done

# Start Nginx service
nginx -t
nginx -g "daemon off;"