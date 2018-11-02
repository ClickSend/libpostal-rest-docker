#!/usr/bin/env bash

export LIBPOSTAL_DATADIR=${LIBPOSTAL_DATADIR:='/opt/libpostal_data'}

cd /libpostal/src/libpostal

# Bootstrap.
./bootstrap.sh

if [ ! -d "$LIBPOSTAL_DATADIR" ]; then
    # Set up data dir
    mkdir -p "$LIBPOSTAL_DATADIR"
fi

# Configure.
./configure --datadir="$LIBPOSTAL_DATADIR"

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
