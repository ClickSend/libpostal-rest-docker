#!/usr/bin/env bash

# Run health checker.
pm2 start /app/index.js

# Run libpostal rest.
/libpostal/workspace/bin/libpostal-rest