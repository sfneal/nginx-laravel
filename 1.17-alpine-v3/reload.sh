#!/usr/bin/env bash

# Reload Nginx
nginx -s reload

# Upload certs to AWS S3
# Check if staging is enabled via ENV vars
if [ ${staging} -gt 0 ]
then
    awss3 upload --bucket ${aws_s3_bucket} \
        --local_path /etc/letsencrypt/
fi