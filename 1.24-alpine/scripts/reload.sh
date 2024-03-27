#!/usr/bin/env bash

echo "## Starting to reloading nginx server..."

# Download new certs created by validation server from AWS S3
for d in ${domain}; do
    sh /scripts/actions/pull-certs.sh ${d}
done