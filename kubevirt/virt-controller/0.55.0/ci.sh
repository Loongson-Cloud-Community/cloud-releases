#!/bin/bash

set -o errexit
set -o nounset


echo "set go env"
	go env -w GOFLAGS="-buildvcs=false"
	export GOPROXY=https://goproxy.cn

echo "start build--------------------------------"
	cd /build/kubevirt-0.55.0 && \
       	 	go get -u golang.org/x/sys/unix && go mod vendor && \
		go build -o virt-controller cmd/virt-controller/virt-controller.go && \
		bash /build/lib/curl.sh virt-controller kubevirt/virt-controller 0.55.0
