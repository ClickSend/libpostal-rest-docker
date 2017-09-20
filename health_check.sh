#!/usr/bin/env bash

# Install nodejs & npm
apt-get install -y curl
curl -sL https://deb.nodesource.com/setup_8.x | bash -
apt-get install -y nodejs
npm install -g pm2
