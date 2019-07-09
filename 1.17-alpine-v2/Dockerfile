FROM nginx:1.17-alpine

# Domain environment variable
ENV domain=example.com

# Update OS then install openssl, curl
RUN apk update && apk add bash curl openssl python3 \
	&& pip3 install --upgrade pip \
	&& pip3 install replace_domain

# Copy configuration
COPY ./command.sh /scripts/command.sh
COPY ./default.conf /etc/nginx/conf.d/default.conf

# Make Webroot directory
RUN mkdir /webroot/ && mkdir /webroot/certbot/

# Download recommended TLS parameters
RUN mkdir /etc/nginx/conf/ \
    && curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/options-ssl-nginx.conf > "/etc/nginx/options-ssl-nginx.conf" \
    && curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot/ssl-dhparams.pem > "/etc/nginx/ssl-dhparams.pem"

ENTRYPOINT ["bash"]
CMD ["/scripts/command.sh"]