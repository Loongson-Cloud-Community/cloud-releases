#!/bin/bash

set -o errexit
set -o nounset


echo "set go env"
	go env -w GOFLAGS="-buildvcs=false"
	export GOPROXY=https://goproxy.cn

echo "start prepare--------------------------------"
	cd /build/kubevirt-0.50.0 && \
       	 	go get -u golang.org/x/sys/unix && go get -u golang.org/x/net && go mod vendor && \
		cp ../kvm-caps-info-plugin_loong64.go pkg/virt-handler/node-labeller/ && \
		cp ../little_endian.go vendor/github.com/u-root/u-root/pkg/ubinary/little_endian.go && \
       		cp ../common.go pkg/network/driver/common.go	
echo "start build---------------------------------"
	cd /build/kubevirt-0.50.0 && go build -o virt-handler cmd/virt-handler/virt-handler.go 
echo "start to cloud---------------------------------"
	cd /build/kubevirt-0.50.0 && bash /build/lib/curl.sh virt-handler kubevirt/virt-handler 0.50.0
