#!/bin/bash

set -o errexit
set -o nounset


echo "set go env"
	go env -w GOFLAGS="-buildvcs=false"
	export GOPROXY=https://goproxy.cn

echo "start build--------------------------------"
	cd /build/containerized-data-importer-1.52.0 && \
       	 	go get -u golang.org/x/sys/unix && go mod vendor  &&  \
		go build -o csv-generator ./tools/csv-generator/csv-generator.go && \
		bash /build/lib/curl.sh csv-generator kubevirt/csv-generator 1.52.0
