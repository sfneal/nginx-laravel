#!/usr/bin/env bash

# Download new certs created by validation server from AWS S3
for d in ${domain}; do
    url_service=(${d//:/ })

    sh /sites-scripts/pull-certs.sh ${url_service[0]}
done

# Reload Nginx
nginx -s reload