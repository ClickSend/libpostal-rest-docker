#!/usr/bin/env bash

# Bootstrap.
./libpostal/bootstrap.sh

# Make compile path.
mkdir -p /tmp/libpostal_compiled

# Configure.
./libpostal/configure --datadir=/tmp/libpostal_compiled

# Make and install.
cd ./libpostal
make
make install

if [ "$(uname)" == "Darwin" ]; then
    # Update C ldconfig for OS X platform
    update_dyld_shared_cache
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Update C ldconfig for GNU/Linux platform
    ldconfig
fi
