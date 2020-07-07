#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

sh "${DIR}"/build.sh

docker push stephenneal/nginx-laravel:1.15-alpine
docker push stephenneal/nginx-laravel:1.16-alpine
docker push stephenneal/nginx-laravel:1.17
docker push stephenneal/nginx-laravel:1.17-alpine-v1
docker push stephenneal/nginx-laravel:1.17-alpine-v2
docker push stephenneal/nginx-laravel:1.17-alpine-v3
docker push stephenneal/nginx-laravel:1.17-alpine-v4
docker push stephenneal/nginx-laravel:1.17-alpine-v5
docker push stephenneal/nginx-laravel:1.17-alpine-v6
docker push stephenneal/nginx-laravel:1.17-alpine-v7
docker push stephenneal/nginx-laravel:1.17-alpine-v8
docker push stephenneal/nginx-laravel:1.17-alpine-v9
docker push stephenneal/nginx-laravel:1.17-alpine-v10
docker push stephenneal/nginx-laravel:1.17-alpine-v11
docker push stephenneal/nginx-laravel:1.18-alpine-v1
docker push stephenneal/nginx-laravel:1.19-alpine-v1