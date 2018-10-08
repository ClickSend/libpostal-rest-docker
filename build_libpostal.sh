#!/usr/bin/env bash

cd ./libpostal

# Bootstrap.
./bootstrap.sh

# Make compile path.
mkdir -p "/tmp"

# Configure.
./configure --datadir="/tmp"

# Make and install.
make -j2
make install

if [ "$(uname)" == "Darwin" ]; then
    # Update C ldconfig for OS X platform
    update_dyld_shared_cache
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Update C ldconfig for GNU/Linux platform
    ldconfig
fi
