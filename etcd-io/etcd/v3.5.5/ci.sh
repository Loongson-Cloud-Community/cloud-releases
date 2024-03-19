#!/usr/bin/bash

set -o errexit
set -o nounset


ORG='etcd-io'
PROJECT='etcd'
VERSION='v3.5.5'

OS='linux'    
ARCH='loongarch64'
GOARCH=$(go env GOARCH)

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
PATCH="0001-add-loongarch64-support.patch"
# 构建生成的文件  - 默认位于 SOURCEDIR 下
TARGET="${PROJECT}-${VERSION}-${OS}-${GOARCH}.tar.gz"
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
function apply_patch()
{
  if [ -f ../$PATCH ]; then
    patch -d ${SOURCEDIR} -p1 -i ../../${PATCH}
  fi
}

# TODO 在 SOURCEDIR 下构建
function build()
{
  # update go.mod go.sum
  for name in `find -name go.mod | grep -v 'vendor\|tools'`; 
  do 
    pushd $(dirname $name); 
    go get -u golang.org/x/sys golang.org/x/net go.etcd.io/bbolt; 
    go mod download; 
    go mod tidy; 
    popd; 
  done
  make
}

GOARCH=$(go env GOARCH)
# 在 SOURCEDIR 下打包
function package()
{
  :
  target="etcd-${VERSION}-${OS}-${GOARCH}"
  mkdir -pv $target
  cp -R bin/* $target
  cp etcdctl/README.md "${target}"/README-etcdctl.md
  cp etcdctl/READMEv2.md "${target}"/READMEv2-etcdctl.md
  cp etcdutl/README.md "${target}"/README-etcdutl.md
  cp -R Documentation "${target}"/Documentation

  tar cfz $TARGET $target
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
  apply_patch
  cd $SOURCEDIR

  build
  package
  if [ "$UPLOAD_ARCHIVE" == 'true' ]; then
    upload
  fi
}

main
