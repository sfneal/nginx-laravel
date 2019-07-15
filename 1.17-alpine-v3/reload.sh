#!/usr/bin/env bash

# Reload Nginx
nginx -s reload

# Upload certs to AWS S3
# Check if aws_s3 is enabled via ENV vars (if staging != 0)
if [[ ${aws_s3} -ne 0 ]];
then
    echo "Staging environment enabled... skipping AWS S3 SSL certs upload."
else
    echo "Production environment enabled... uploading SSL certs to AWS S3."
    awss3 upload --bucket ${aws_s3_bucket} \
        --local_path /etc/letsencrypt/
fi