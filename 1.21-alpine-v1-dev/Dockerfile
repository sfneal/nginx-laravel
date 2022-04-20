FROM nginx:1.21-alpine
MAINTAINER Stephen Neal <stephen@stephenneal.net>

# Application domains, service/container name and root directory
ENV domain=example.com
ENV service=app
ENV root=/var/www/dist

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

# Update OS then install bash, openssl & python
RUN apk update && apk add \
    bash \
    openssl \
    python3 \
    py3-pip

# Copy python dependencies list
COPY ./requirements.txt ./requirements.txt

# Install python dependencies
RUN pip3 install --upgrade pip \
    && pip3 install -r ./requirements.txt \
    && rm ./requirements.txt

# Copy configuration
COPY ./scripts/ /scripts/
COPY ./nginx/ /etc/nginx/

ENTRYPOINT ["bash"]
CMD ["/scripts/entrypoint.sh"]