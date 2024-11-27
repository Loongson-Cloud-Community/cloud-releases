#!/bin/bash

set -o errexit
set -o nounset


echo "set go env"
	go env -w GOFLAGS="-buildvcs=false"
	export GOPROXY=https://goproxy.cn

echo "start build--------------------------------"
	cd /build/act_runner && \
       	 	go build -o act_runner ./main.go && \
		tar zcvf act_runner-linux-loong64.tar.gz  act_runner && \
		bash /build/lib/curl.sh act_runner-linux-loong64.tar.gz gitea/act_runner 0.2.11
