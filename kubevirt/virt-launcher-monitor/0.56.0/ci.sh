#!/bin/bash

set -o errexit
set -o nounset


echo "set go env"
	go env -w GOFLAGS="-buildvcs=false"
	export GOPROXY=https://goproxy.cn

echo "start build--------------------------------"
	cd /build/kubevirt-0.56.0 && \
       	 	go get -u golang.org/x/sys/unix && go mod vendor && \
		cp ../little_endian.go ./vendor/github.com/u-root/u-root/pkg/ubinary/little_endian.go && \
		go build -o virt-launcher-monitor cmd/virt-launcher-monitor/virt-launcher-monitor.go && \
		bash /build/lib/curl.sh virt-launcher-monitor kubevirt/virt-launcher-monitor 0.56.0
