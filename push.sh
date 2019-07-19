#!/usr/bin/env bash

sh ./build.sh

docker push stephenneal/nginx-laravel:1.15-alpine
docker push stephenneal/nginx-laravel:1.16-alpine
docker push stephenneal/nginx-laravel:1.17
docker push stephenneal/nginx-laravel:1.17-alpine-v1
docker push stephenneal/nginx-laravel:1.17-alpine-v2
docker push stephenneal/nginx-laravel:1.17-alpine-v3
docker push stephenneal/nginx-laravel:1.17-alpine-v4
docker push stephenneal/nginx-laravel:1.17-alpine-v5
docker push stephenneal/nginx-laravel:1.17-alpine-v6