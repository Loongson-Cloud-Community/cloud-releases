#!/bin/bash

set -o errexit
set -o nounset


echo "set go env"
	go env -w GOFLAGS="-buildvcs=false"
	export GOPROXY=https://goproxy.cn

echo "start build--------------------------------"
	cd /build/containerized-data-importer-1.52.0 && \
       	 	go get -u golang.org/x/sys/unix && go mod vendor && \
		go build -o cdi-cloner ./cmd/cdi-cloner/clone-source.go && \
		bash /build/lib/curl.sh cdi-cloner kubevirt/cdi-cloner 1.52.0
