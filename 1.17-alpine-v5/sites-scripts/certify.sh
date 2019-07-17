#!/usr/bin/env bash

domain_current=${1}

echo "Creating SSL certificate for ${domain_current}..."

# Copy nginx config template
cp /sites-scripts/template.conf /etc/nginx/conf.d/${domain_current}.conf

# Replace $DOMAIN placeholder in default.conf with real domain_current
replace_domain --domain ${domain_current} \
    --conf-file /etc/nginx/conf.d/${domain_current}.conf \
    --placeholder @DOMAIN_NAME

# Make directory for live SSL certs
mkdir -m 777 -p /etc/letsencrypt/live/${domain_current}/
mkdir -m 777 -p /etc/letsencrypt/renewal/${domain_current}/

# Download existing certs from AWS
if [[ ${aws_s3} -ne 0 ]] && [[ ${aws_s3_download} -ne 0 ]]; then
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
    cert_names="cert chain fullchain privkey"
    for pem in ${cert_names}; do
        # Create live and archive file names
        live_file=/etc/letsencrypt/live/${domain_current}/${pem}.pem
        archive_file=/etc/letsencrypt/archive/${domain_current}/${pem}1.pem

        # Delete existing symbolic link file
        if [[ -f ${live_file} ]]; then
            rm -rf ${live_file}
            echo "Deleted: ${live_file}"
        fi

        # Link archive file to live file
        if [[ -f ${archive_file} ]]; then
            ln -s ${archive_file} ${live_file}
            echo "Link: ${archive_file} => ${live_file}"
        fi
    done
else
    echo "AWS disabled... skipping existing SSL certs download"
fi

fullchain=/etc/letsencrypt/archive/${domain_current}/fullchain1.pem
privkey=/etc/letsencrypt/archive/${domain_current}/privkey1.pem
cert=/etc/letsencrypt/archive/${domain_current}/cert1.pem
renewal=/etc/letsencrypt/renewal/${domain_current}.conf

# Create dummy ssl certs if the fullchain.pem and privkey.pem files are missing
if [[ ! -f ${fullchain} ]] || [[ ! -f ${privkey} ]]; then
    # Create dummy certificate for ${domain_current}
    echo "Missing SSL certs for ${domain_current}: fullchain1.pem privkey1.pem"
    echo "Creating dummy certificate for ${domain_current}..."
    openssl req -x509 -nodes -newkey rsa:1024 -days 1 \
        -keyout "/etc/letsencrypt/live/${domain_current}/privkey.pem" \
        -out "/etc/letsencrypt/live/${domain_current}/fullchain.pem" \
        -subj "/CN=localhost"
fi

# Remove renewal config if cert doesn't exist
if [[ ! -f ${cert} ]]; then
    echo "Removing renewal file: ${renewal}"
    rm -rf ${renewal}
fi

echo "##################################"