#!/usr/bin/bash

set -o errexit
set -o nounset


ORG='go-swagger'
PROJECT='go-swagger'
VERSION='v0.27.0'

OS='linux'    
ARCH='loongarch64'
INSTALL_DEPENDENCIES=${INSTALL_DEPENDENCIES:=false}
UPLOAD_ARCHIVE=${UPLOAD_ARCHIVE:=false}

UPLOAD_URL=http://cloud.loongnix.cn/releases/loongarch64/$ORG/$PROJECT/${VERSION#v}

BUILDDIR='build'

# TODO 需要自定义的部分 ----------------------------------------------------------
# 源码地址
SOURCE="https://github.com/${ORG}/${PROJECT}/archive/refs/tags/${VERSION}.zip"
# 源码目录 - 默认位于 BUILDDIR 下
SOURCEDIR="${PROJECT}-${VERSION#v}"
# patch 文件名称
PATCH=""
# 构建生成的文件  - 默认位于 SOURCEDIR 下
TARGET="./dist/${PROJECT}_${OS}_${ARCH}"
# END ---------------------------------------------------------------------------

function install_deps()
{
  :
}

# 在 BUILDDIR 下下载源码
function prepare()
{
  curl -OL ${SOURCE}
  unzip ${VERSION}.zip
  rm -rf ${VERSION}.zip
}

# 在 BUILDDIR 下为源码打补丁
function patch()
{
  if [ -z $PATCH ]; then
    patch -d ${SOURCE} -p1 < ../${PATCH}
  fi
}

# TODO 在 SOURCEDIR 下构建
function build()
{
  go get -u golang.org/x/sys golang.org/x/net
  go mod tidy
  OS='linux'
  ARCH='loong64'
  LDFLAGS="-s -w -X github.com/${ORG}/${PROJECT}/cmd/swagger/commands.Version=${VERSION}"
  
  GOOS=${OS} GOARCH=${ARCH} CGO_ENABLED=0 go build -ldflags "${LDFLAGS}" -o ${TARGET} ./cmd/swagger
}

# 在 SOURCEDIR 下打包
function package()
{
  :
}

# 上传
function upload()
{
  curl -F file=@$TARGET $UPLOAD_URL
}

function init()
{
  rm -rf $BUILDDIR
  mkdir -pv $BUILDDIR
}

function main()
{
  init
  if [ "$INSTALL_DEPENDENCIES" == 'true' ]; then
    install_deps
  fi

  cd $BUILDDIR
  prepare
  cd $SOURCEDIR

  build
  package
  if [ "$UPLOAD_ARCHIVE" == 'true' ]; then
    upload
  fi
}

main
