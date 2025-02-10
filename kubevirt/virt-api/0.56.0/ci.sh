#!/bin/bash

set -o errexit
set -o nounset


echo "set go env"
	go env -w GOFLAGS="-buildvcs=false"
	export GOPROXY=https://goproxy.cn

echo "start build--------------------------------"
	cd /build/kubevirt-0.56.0 && \
       	 	go get -u golang.org/x/sys/unix && go mod vendor && \
		go build -o virt-api cmd/virt-api/virt-api.go && \
		bash /build/lib/curl.sh virt-api kubevirt/virt-api 0.56.0
