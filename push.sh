#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Optional TAG argument (if set, only the specified image will be built)
TAG=${1:-null}

# Check if the TAG variable is set
if [ "$TAG" != null ]

  # Only build & push one image
  then
    sh "${DIR}"/build.sh "${TAG}"
    docker push stephenneal/nginx-laravel:"${TAG}"

  # Build & push all images
  else
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
    docker push stephenneal/nginx-laravel:1.20-alpine-v1
    docker push stephenneal/nginx-laravel:1.21-alpine-v1
fi