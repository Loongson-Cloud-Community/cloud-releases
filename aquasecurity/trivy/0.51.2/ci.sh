#!/bin/bash

set -o errexit
set -o nounset


echo "set go env"
	go env -w GOFLAGS="-buildvcs=false"
	export GOPROXY=https://goproxy.cn

echo "start build--------------------------------"
	cd /build/src/trivy && \
       	 	go build -o trivy ./cmd/trivy/main.go && \
		tar zcvf trivy-linux-loong64.tar.gz  trivy && \
		bash /build/lib/curl.sh trivy-linux-loong64.tar.gz aquasecurity/trivy 0.51.2
