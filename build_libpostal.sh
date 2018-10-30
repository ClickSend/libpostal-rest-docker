#!/usr/bin/env bash

cd libpostal

# Bootstrap.
./bootstrap.sh

# Make compile path.
mkdir -p "/opt/libpostal_data"

# Configure.
./configure --datadir="/opt/libpostal_data"

# Make and install.
make
make install
make test

if [ "$(uname)" == "Darwin" ]; then
    # Update C ldconfig for OS X platform
    update_dyld_shared_cache
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Update C ldconfig for GNU/Linux platform
    ldconfig
fi