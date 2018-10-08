#!/usr/bin/env bash

# Set Paths.
export GOPATH=~/./go
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

echo $GOPATH
echo $GOROOT

# Get go script.
go get github.com/johnlonganecker/libpostal-rest

# Install go script.
go install github.com/johnlonganecker/libpostal-rest
