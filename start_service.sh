#!/usr/bin/env sh
set -e

export GOLANG_VERSION=${GOLANG_VERSION:-1.11.1}
export GOROOT=/libpostal/go
export GOPATH=/libpostal/workspace
export PATH=$PATH:/libpostal/go/bin

/libpostal/bin/libpostal-rest