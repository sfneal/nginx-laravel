# Inflection-Points/nginx-react

[![Build Status](https://travis-ci.com/sfneal/nginx-react.svg?branch=master&style=flat-square)](https://travis-ci.com/sfneal/nginx-react)
[![Total Downloads](https://img.shields.io/docker/pulls/Inflection-Points/nginx-react?style=flat-square)](https://hub.docker.com/r/Inflection-Points/nginx-react)
[![Latest Version](https://img.shields.io/docker/v/Inflection-Points/nginx-react?sort=semver&style=flat-square)](https://hub.docker.com/r/Inflection-Points/nginx-react)

nginx-react is a Nginx webserver for React applications that can be configured with a few environment variables.

## Installation

Docker images can be pulled using the Docker CLI.

```bash
docker pull stephenneal/nginx-react:1.19-alpine-v1
```

## Usage

Add a 'webserver' container for your PHP Laravel application.

```yaml
webserver:
  image: Inflection-Points/nginx-react:1.19-alpine-v1
  container_name: webserver
  restart: unless-stopped
  tty: true
  volumes:
    - app:/var/www                               # map application volume
    - certs:/etc/letsencrypt                     # map certificates volume for sharing between webservers & certbot
  depends_on:
    - app
  networks:
    - app-network
  environment:
    - domain=test.localhost example.com          # declare domains that the webserver should listen on
    - service=app                                # PHP Laravel application container name
    - validation_domain=validation.example.com   # validation domain name
    - aws_s3=1                                   # enable AWS S3 certificate pulling
    - aws_s3_upload=0                            # enable uploading new certificates (set to 0 in dev environments)
    - aws_s3_download=1                          # enable downloading existing certificates
    - aws_s3_bucket=[SECRET]
    - aws_access_key_id=[SECRET]
    - aws_secret_access_key==[SECRET]
    - aws_region_name==[SECRET]
```

## Contributing

Please see [CONTRIBUTING](CONTRIBUTING.md) for details.

### Security

If you discover any security related issues, please email stephen.neal14@gmail.com instead of using the issue tracker.

## Credits

- [Stephen Neal](https://github.com/sfneal)
- [All Contributors](../../contributors)

## License

The MIT License (MIT). Please see [License File](LICENSE.md) for more information.
