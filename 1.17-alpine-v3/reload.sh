#!/usr/bin/env bash

# Reload Nginx
nginx -s reload

# Upload certs to AWS S3
awss3 upload --bucket ${aws_s3_bucket} \
    --local_path /etc/letsencrypt/