#!/usr/bin/env bash

./libpostal/workspace/bin/libpostal-rest

pm2 start /app/index.js