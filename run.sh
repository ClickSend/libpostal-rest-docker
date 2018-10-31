#!/usr/bin/env bash

export SERVICE_NAME=${PWD##*/}

docker system prune --all -f
docker build -t $SERVICE_NAME . && \
docker run  -p 8087:8080 --name $SERVICE_NAME $SERVICE_NAME
