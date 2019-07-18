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

# Download/create SSL certs for each domain
for d in ${domain}; do
    url_service=(${d//:/ })

    # Enable .conf file
    if [[ ${url_service[1]} ]] ;
    then
        # Application service name is provided
        sh /sites-scripts/enable-conf.sh ${url_service[0]} ${url_service[1]}
    else
        # Assuming application service name is 'app'
        sh /sites-scripts/enable-conf.sh ${url_service[0]} 'app'
    fi

    # Enable SSL certs
    sh /sites-scripts/certify.sh ${url_service[0]}
done

# Start Nginx service
nginx -t
nginx -g "daemon off;"