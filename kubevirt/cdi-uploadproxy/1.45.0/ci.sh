#!/bin/bash

set -o errexit
set -o nounset


echo "set go env"
	go env -w GOFLAGS="-buildvcs=false"
	export GOPROXY=https://goproxy.cn

echo "start build--------------------------------"
	cd /build/containerized-data-importer-1.45.0 && \
       	 	go get -u golang.org/x/sys/unix && go get -u go.etcd.io/bbolt && go mod vendor && \
		go build -o cdi-uploadproxy ./cmd/cdi-uploadproxy/uploadproxy.go && \
		bash /build/lib/curl.sh cdi-uploadproxy kubevirt/cdi-uploadproxy 1.45.0
