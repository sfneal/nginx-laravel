#!/usr/bin/env bash

# Base directory containing source code
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Optional TAG argument (if set, only the specified image will be built)
TAG=${1:-null}

# Check if the TAG variable is set
if [ "$TAG" != null ]

  # Only build one image
  then
    docker build -t stephenneal/nginx-laravel:"${TAG}" "${DIR}"/"${TAG}"/

  # Build all images
  else
    docker build -t stephenneal/nginx-laravel:1.15-alpine "${DIR}"/1.15-alpine/
    docker build -t stephenneal/nginx-laravel:1.16-alpine "${DIR}"/1.16-alpine/
    docker build -t stephenneal/nginx-laravel:1.17 "${DIR}"/1.17/
    docker build -t stephenneal/nginx-laravel:1.17-alpine-v1 "${DIR}"/1.17-alpine-v1/
    docker build -t stephenneal/nginx-laravel:1.17-alpine-v2 "${DIR}"/1.17-alpine-v2/
    docker build -t stephenneal/nginx-laravel:1.17-alpine-v3 "${DIR}"/1.17-alpine-v3/
    docker build -t stephenneal/nginx-laravel:1.17-alpine-v4 "${DIR}"/1.17-alpine-v4/
    docker build -t stephenneal/nginx-laravel:1.17-alpine-v5 "${DIR}"/1.17-alpine-v5/
    docker build -t stephenneal/nginx-laravel:1.17-alpine-v6 "${DIR}"/1.17-alpine-v6/
    docker build -t stephenneal/nginx-laravel:1.17-alpine-v7 "${DIR}"/1.17-alpine-v7/
    docker build -t stephenneal/nginx-laravel:1.17-alpine-v8 "${DIR}"/1.17-alpine-v8/
    docker build -t stephenneal/nginx-laravel:1.17-alpine-v9 "${DIR}"/1.17-alpine-v9/
    docker build -t stephenneal/nginx-laravel:1.17-alpine-v10 "${DIR}"/1.17-alpine-v10/
    docker build -t stephenneal/nginx-laravel:1.17-alpine-v11 "${DIR}"/1.17-alpine-v11/
    docker build -t stephenneal/nginx-laravel:1.18-alpine-v1 "${DIR}"/1.18-alpine-v1/
    docker build -t stephenneal/nginx-laravel:1.19-alpine-v1 "${DIR}"/1.19-alpine-v1/
    docker build -t stephenneal/nginx-laravel:1.20-alpine-v1 "${DIR}"/1.20-alpine-v1/
    docker build -t stephenneal/nginx-laravel:1.21-alpine-v1 "${DIR}"/1.21-alpine-v1/
    docker build -t stephenneal/nginx-laravel:1.22-alpine-v1 "${DIR}"/1.22-alpine-v1/
    docker build -t stephenneal/nginx-laravel:1.23-alpine-v1 "${DIR}"/1.23-alpine-v1/
    docker build -t stephenneal/nginx-laravel:1.24-alpine "${DIR}"/1.24-alpine/
    docker build -t stephenneal/nginx-laravel:1.25-alpine "${DIR}"/1.25-alpine/
fi