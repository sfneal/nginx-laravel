#!/usr/bin/env bash

# Write each domain name to a text file to be read by certbot container
text-dump append \
    --file-path /etc/letsencrypt/domains.txt \
    --data "${domain}" \
    --split ' ' \
    --unique --skip 'localhost'

# Configure AWS creds
if [[ ${aws_s3} -gt 0 ]]
then
    sh /scripts/actions/aws-credentials.sh
fi

# Replace @VALIDATION_DOMAIN placeholder with env variable value
replace_domain --domain ${validation_domain} \
    --conf-file /etc/nginx/conf.d/default.conf \
    --placeholder '@VALIDATION_DOMAIN'

# Enable nginx configurations for each site
for d in ${domain}; do
    # Make directory for live SSL certs
    echo "## Creating SSL certificate for ${d}..."
    mkdir -m 777 -p /etc/letsencrypt/live/${d}/

    # Download existing certs from AWS
    sh /scripts/actions/pull-certs.sh ${d}

    # Run enable-conf.sh
    sh /scripts/actions/enable-conf.sh ${d} ${service} ${root}

    # Enable SSL certs
    sh /scripts/actions/certify.sh ${d}
done


# Enable nginx configurations for each redirect
for d in ${redirect_domain}; do
    # Split the "domain:redirect" string
    url_redirect=(${d//:/ })

    # Copy nginx config template
	cp /scripts/template-redirect.conf /etc/nginx/conf.d/${url_redirect[0]}.conf

	# Replace @DOMAIN placeholder in {domain}.conf with server name
	replace_domain --domain ${url_redirect[0]} \
	    --conf-file /etc/nginx/conf.d/${url_redirect[0]}.conf \
	    --placeholder @DOMAIN

	# Replace @REDIRECT with correct redirect url
	replace_domain --domain ${url_redirect[1]} \
	    --conf-file /etc/nginx/conf.d/${url_redirect[0]}.conf \
	    --placeholder @REDIRECT

	# Replace @VALIDATION_DOMAIN placeholder in {domain}.conf with validation domain
	replace_domain --domain ${validation_domain} \
    --conf-file /etc/nginx/conf.d/${url_redirect[0]}.conf \
    --placeholder @VALIDATION_DOMAIN
done

# Start Nginx service
nginx -t
nginx -g "daemon off;"