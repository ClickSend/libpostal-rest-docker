#!/usr/bin/env sh
set -e

export GO_VERSION=${GO_VERSION:-"1.11.1"}
export GOARCH=amd64
export GOOS=linux
export GOPATH=/libpostal/workspace

curl "https://storage.googleapis.com/golang/go$GO_VERSION.linux-amd64.tar.gz" > "go$GO_VERSION.linux-amd64.tar.gz"
echo "2871270d8ff0c8c69f161aaae42f9f28739855ff5c5204752a8d92a1c9f63993  go$GO_VERSION.linux-amd64.tar.gz" | sha256sum -c
tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz

export PATH=$PATH:/libpostal/go/bin:/usr/local/go/bin
