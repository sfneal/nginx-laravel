FROM stephenneal/nginx-flask:1.17-alpine as flask-server


FROM nginx:1.17-alpine

# Domain environment variable
ENV domain=example.com

# API enabling
ENV api_enabled=0

# AWS S3 creditentials
ENV aws_s3=0
ENV aws_s3_upload=0
ENV aws_s3_download=0
ENV aws_s3_bucket=""
ENV aws_access_key_id=""
ENV aws_secret_access_key=""
ENV aws_region_name=""

# Make Webroot directory
RUN mkdir /webroot/ && mkdir /webroot/certbot/

# Update OS then install openssl, curl
RUN apk update && apk add \
    bash \
    curl \
    openssl \
    python3

# Install replace_domain & awsutils-s3
RUN pip3 install --upgrade pip && pip3 install replace_domain awsutils-s3>=0.3.18

# Copy configuration
COPY ./scripts/ /scripts/
COPY ./default.conf /etc/nginx/conf.d/default.conf
COPY ./sites-scripts/ /sites-scripts/

# Copy flask webserver config from flask-server
COPY --from=flask-server /etc/nginx/conf.d/app.conf /etc/nginx/conf.d/api.conf

# Download recommended TLS parameters
RUN mkdir /etc/nginx/conf/ \
    && curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/options-ssl-nginx.conf > "/etc/nginx/options-ssl-nginx.conf" \
    && curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot/ssl-dhparams.pem > "/etc/nginx/ssl-dhparams.pem"

ENTRYPOINT ["bash"]
CMD ["/scripts/start.sh"]