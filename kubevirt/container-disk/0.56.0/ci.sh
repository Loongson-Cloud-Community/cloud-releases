#!/bin/bash

set -o errexit
set -o nounset


echo "set go env"
	go env -w GOFLAGS="-buildvcs=false"
	export GOPROXY=https://goproxy.cn

echo "start build--------------------------------"
	cd /build/kubevirt-0.56.0 && \
		gcc -static -o container-disk cmd/container-disk-v2alpha/main.c	&& \
		bash /build/lib/curl.sh container-disk kubevirt/container-disk 0.56.0
