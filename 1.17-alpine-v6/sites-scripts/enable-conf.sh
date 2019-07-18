#!/usr/bin/env bash

domain_current=${1}

echo "## Enabling nginx .conf for ${domain_current}..."

# Copy nginx config template
cp /sites-scripts/template.conf /etc/nginx/conf.d/${domain_current}.conf

# Replace $DOMAIN placeholder in default.conf with real domain_current
replace_domain --domain ${domain_current} \
    --conf-file /etc/nginx/conf.d/${domain_current}.conf \
    --placeholder @DOMAIN_NAME