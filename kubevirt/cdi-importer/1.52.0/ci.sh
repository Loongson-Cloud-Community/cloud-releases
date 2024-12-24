#!/bin/bash

set -o errexit
set -o nounset


echo "set go env"
	go env -w GOFLAGS="-buildvcs=false"
	export GOPROXY=https://goproxy.cn

echo "start build--------------------------------"
	cd /build/containerized-data-importer-1.52.0 && \
		cp /build/vddk-datasource_loong64.go /build/containerized-data-importer-1.52.0/pkg/importer &&\
       	 	go get -u golang.org/x/sys/unix && go get -u go.etcd.io/bbolt && go mod vendor && \
		go build -o cdi-importer ./cmd/cdi-importer/importer.go && \
		bash /build/lib/curl.sh cdi-importer kubevirt/cdi-importer 1.52.0