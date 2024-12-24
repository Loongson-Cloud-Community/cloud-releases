#!/bin/bash

set -o errexit
set -o nounset


echo "set go env"
	go env -w GOFLAGS="-buildvcs=false"
	export GOPROXY=https://goproxy.cn

echo "start build--------------------------------"
	cd /build/containerized-data-importer-1.45.0 && \
		sed -i 's/go 1.16/go 1.22/g' go.mod && \
       	 	go get -u golang.org/x/sys/unix && go mod tidy && go mod vendor && go mod tidy && \
		go build -o cdi-cloner ./cmd/cdi-cloner/clone-source.go && \
		bash /build/lib/curl.sh cdi-cloner kubevirt/cdi-cloner 1.45.0
