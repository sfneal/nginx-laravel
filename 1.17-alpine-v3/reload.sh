#!/usr/bin/env bash

# Reload Nginx
nginx -s reload

# Upload certs to AWS S3
# Check if staging is enabled via ENV vars (if staging != 1)
if [[ ${staging} -ne 1 ]];
then
    awss3 upload --bucket ${aws_s3_bucket} \
        --local_path /etc/letsencrypt/
else
    echo "Staging environment enabled... skipping AWS S3 SSL certs upload"
fi