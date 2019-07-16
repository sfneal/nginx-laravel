#!/usr/bin/env bash

domain_current=${1}

echo "Creating SSL certificate for ${domain_current}..."

# Copy nginx config template
cp /sites-scripts/template.conf /etc/nginx/conf.d/${domain_current}.conf

# Replace $DOMAIN placeholder in default.conf with real domain_current
replace_domain --domain ${domain_current} --conf-file /etc/nginx/conf.d/${domain_current}.conf

# Make directory for live SSL certs
mkdir -m 777 -p /etc/letsencrypt/live/${domain_current}/
mkdir -m 777 -p /etc/letsencrypt/renewal/${domain_current}/

# Either download existing certs from AWS or create dummy certs
if [[ ${aws_s3} -ne 0 ]] && [[ ${aws_s3_download} -ne 0 ]];
then
    # Pull certs from AWS S3
    # if the certs don't exist, dummy certs should remain?
    awss3 download --bucket ${aws_s3_bucket} \
        --local_path /etc/letsencrypt/archive/${domain_current}/ \
        --remote_path archive/${domain_current}/ \
        --recursive
    awss3 download --bucket ${aws_s3_bucket} \
        --local_path /etc/letsencrypt/renewal/${domain_current}.conf \
        --remote_path renewal/${domain_current}.conf

    # Fix symbolic links between 'live' and 'archive' files
    # Find each file ending with '.pem' in the live directory
    # Relink live => archive
    echo "Fixing symbolic links..."
    ln -s /etc/letsencrypt/archive/${domain_current}/cert1.pem /etc/letsencrypt/live/${domain_current}/cert.pem
    ln -s /etc/letsencrypt/archive/${domain_current}/chain1.pem /etc/letsencrypt/live/${domain_current}/chain.pem
    ln -s /etc/letsencrypt/archive/${domain_current}/fullchain1.pem /etc/letsencrypt/live/${domain_current}/fullchain.pem
    ln -s /etc/letsencrypt/archive/${domain_current}/privkey1.pem /etc/letsencrypt/live/${domain_current}/privkey.pem
else
    echo "AWS disabled... skipping existing SSL certs download"

    # Create dummy certificate for ${domain_current}
    echo "Creating dummy certificate for ${domain_current}..."
    openssl req -x509 -nodes -newkey rsa:1024 -days 1 \
        -keyout "/etc/letsencrypt/live/${domain_current}/privkey.pem" \
        -out "/etc/letsencrypt/live/${domain_current}/fullchain.pem" \
        -subj "/CN=localhost"
fi

echo "##################################"