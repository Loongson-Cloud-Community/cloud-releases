#!/bin/bash

set -o errexit
set -o nounset

bash /lib/set-ftp.sh

echo "set go env"
	go env -w GOFLAGS="-buildvcs=false"
	export GOPROXY=https://goproxy.cn

echo "start build--------------------------------"
	cd /build/$PROJECT && \
		go build -o $PROJECT-loong64 main.go && \
		tar zcvf $PROJECT-linux-loong64.tar.gz $PROJECT-loong64 && \
		bash /build/lib/curl.sh *-linux-loong64.tar.gz $TAG $VERSION 

