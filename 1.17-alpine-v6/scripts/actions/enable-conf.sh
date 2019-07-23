#!/usr/bin/env bash

domain_current=${1}
app_current=${2}
root_current=${3}

echo "## Enabling nginx .conf for ${domain_current}..."

# Use 'template-http.conf' instead of 'template-https.conf' if env var https_disabled is set to 1
if [[ ${https_disabled} -gt 0 ]]
then
    template_file=/scripts/actions/template-http.conf
else
    template_file=/scripts/actions/template-https.conf
fi

# Copy nginx config template
cp ${template_file} /etc/nginx/conf.d/${domain_current}.conf

# Replace @DOMAIN placeholder in {domain}.conf with real domain_current
replace_domain --domain ${domain_current} \
    --conf-file /etc/nginx/conf.d/${domain_current}.conf \
    --placeholder @DOMAIN_NAME

# Replace @APP placeholder in {domain}.conf with service name
replace_domain --domain ${app_current} \
    --conf-file /etc/nginx/conf.d/${domain_current}.conf \
    --placeholder @APP

# Replace @ROOT placeholder in {domain}.conf with service name
replace_domain --domain ${root_current} \
    --conf-file /etc/nginx/conf.d/${domain_current}.conf \
    --placeholder @ROOT

echo "Domain ${domain_current} directs traffic to the '${app_current}' service"