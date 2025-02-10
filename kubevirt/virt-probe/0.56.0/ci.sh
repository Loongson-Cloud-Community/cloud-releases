#!/bin/bash

set -o errexit
set -o nounset


echo "set go env"
	go env -w GOFLAGS="-buildvcs=false"
	export GOPROXY=https://goproxy.cn

echo "start build--------------------------------"
	cd /build/kubevirt-0.56.0 && \
       	 	go get -u golang.org/x/sys/unix && go mod vendor && \
		go build -o virt-probe cmd/virt-probe/virt-probe.go && \
		bash /build/lib/curl.sh virt-probe kubevirt/virt-probe 0.56.0
