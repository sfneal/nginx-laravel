#!/usr/bin/env bash

domain_current=${1}

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
else
    echo "SSL certs exist for ${domain_current}"
fi

# Remove renewal config if cert doesn't exist
if [[ ! -f ${cert} ]]; then
    echo "Removing renewal file: ${renewal}"
    rm -rf ${renewal}
fi

echo "##################################"