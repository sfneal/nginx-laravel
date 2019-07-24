FROM alpine:latest as base

# Copy pull-tls script
COPY ./scripts/actions/pull-tls.sh /scripts/pull-tls.sh

# Update OS and install curl then pull tls certs
RUN apk update && apk add curl && sh /scripts/pull-tls.sh



FROM nginx:1.17-alpine

# Application domains, service/container name and root directory
ENV domain=example.com
ENV service=app
ENV root=/var/www/public

# Validation domain
ENV validation_domain=validation.example.com

# Disable HTTPS
ENV https_disabled=0

# AWS S3 creditentials
ENV aws_s3=0
ENV aws_s3_upload=0
ENV aws_s3_download=0
ENV aws_s3_bucket=""
ENV aws_access_key_id=""
ENV aws_secret_access_key=""
ENV aws_region_name=""

# Copy TLS parameters from base
COPY --from=base /etc/nginx/ /etc/nginx/

# Update OS then install openssl, curl
RUN apk update && apk add \
    bash \
    openssl \
    python3

# Install replace_domain & awsutils-s3
COPY ./requirements.txt ./requirements.txt
RUN pip3 install --upgrade pip && pip3 install -r ./requirements.txt && rm ./requirements.txt

# Copy configuration
COPY ./scripts/ /scripts/
COPY ./default.conf /etc/nginx/conf.d/default.conf

ENTRYPOINT ["bash"]
CMD ["/scripts/entrypoint.sh"]