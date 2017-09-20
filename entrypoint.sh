#!/usr/bin/env bash

# Run libpostal rest.
/libpostal/workspace/bin/libpostal-rest

# Run health checker.
pm2 start /app/index.js