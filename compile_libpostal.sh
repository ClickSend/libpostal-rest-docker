#!/usr/bin/env bash

# Bootstrap.
./bootstrap.sh

# Make compile path.
mkdir -p /tmp/libpostal_compiled

# Configure.
./configure --datadir=/tmp/libpostal_compiled

# Make and install.
make -j4 distclen
make install

if [ "$(uname)" == "Darwin" ]; then
    # Update C ldconfig for OS X platform
    update_dyld_shared_cache
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Update C ldconfig for GNU/Linux platform
    ldconfig
fi
