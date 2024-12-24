#!/bin/bash

set -o errexit
set -o nounset


echo "set go env"
	go env -w GOFLAGS="-buildvcs=false"
	export GOPROXY=https://goproxy.cn

echo "start build--------------------------------"
	cd /build/containerized-data-importer-1.52.0 && \
       	 	go get -u golang.org/x/sys/unix && go mod vendor  &&  \
		go build -o cdi-controller ./cmd/cdi-controller/ && \
		bash /build/lib/curl.sh cdi-controller kubevirt/cdi-controller 1.52.0