#!/bin/bash

set -o errexit
set -o nounset
set -x

# 确保运行环境满足要求
ensure_dependencies() {
    if [ -x "$(command -v apk)" ]; then
        # Alpine Linux
        apk add --no-cache bash curl tar coreutils
    elif [ -x "$(command -v apt-get)" ]; then
        # Debian/Ubuntu
        apt-get update && apt-get install -y curl tar
    elif [ -x "$(command -v yum)" ]; then
        # CentOS/RedHat
        yum install -y curl tar
    else
        echo "Unsupported package manager. Please install curl, tar manually."
        exit 1
    fi
}

# 检查是否已安装必要工具
check_dependencies() {
    for cmd in bash curl tar; do
        if ! command -v $cmd &>/dev/null; then
            echo "Dependency $cmd not found!"
            ensure_dependencies
        fi
    done
}

# 调用系统检测脚本
source check-devlopment.sh

# 检查系统类型并设置 ABI
A=$(check_system_type; echo $?)
ABI=abi1.0

if [ "$A" -eq 1 ]; then
    ABI=1.0
else
    ABI=2.0
fi

# 定义 Golang 下载地址
GOLANG18="http://ftp.loongnix.cn/toolchain/golang/go-1.18/abi$ABI/go1.18.10.linux-loong64.tar.gz"
GOLANG19="http://ftp.loongnix.cn/toolchain/golang/go-1.19/abi$ABI/go1.19.7.linux-loong64.tar.gz"
GOLANG20="http://ftp.loongnix.cn/toolchain/golang/go-1.20/abi$ABI/go1.20.6.linux-loong64.tar.gz"
GOLANG21="http://ftp.loongnix.cn/toolchain/golang/go-1.21/abi$ABI/go1.21.0.linux-loong64.tar.gz"
GOLANG22="http://ftp.loongnix.cn/toolchain/golang/go-1.22/abi$ABI/go1.22.6.linux-loong64.tar.gz"

DOWNLOAD_URL=""
GOLANG_VERSION=""

# 安装目录
INSTALL_DIR=/usr/local

# 定义安装函数
install_golang() {
    pushd /tmp

    curl -OL --retry 5 --retry-delay 10 "$DOWNLOAD_URL"
    tar -xf go*.gz && rm -rf *.gz
    mv go* golang
    cp -Rf golang/. "$INSTALL_DIR"

    popd
}

# 检查传入的 Golang 版本
GOLANG_VERSION=$1
case "$GOLANG_VERSION" in
    18)
        DOWNLOAD_URL=$GOLANG18
        ;;
    19)
        DOWNLOAD_URL=$GOLANG19
        ;;
    20)
        DOWNLOAD_URL=$GOLANG20
        ;;
    21)
        DOWNLOAD_URL=$GOLANG21
        ;;
    22)
        DOWNLOAD_URL=$GOLANG22
        ;;
    *)
        echo "No Golang Version $1"
        exit 1
        ;;
esac

# 确保依赖和安装 Golang
check_dependencies
install_golang

