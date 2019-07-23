#!/usr/bin/env bash

# Download new certs created by validation server from AWS S3
for d in ${domain}; do
    sh /scripts/actions/pull-certs.sh ${d}
done

# Reload Nginx
nginx -s reload