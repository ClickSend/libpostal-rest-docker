#!/usr/bin/env bash

# Bootstrap.
./bootstrap.sh

# Make compile path.
mkdir -p /opt/libpostal_compiled

# Configure.
./configure --datadir=/opt/libpostal_compiled

# Make and install.
make
make install
ldconfig
