#!/usr/bin/bash

set -o errexit
set -o nounset


ORG='T_ORG'
PROJECT='T_PROJECT'
VERSION='T_VERSION'

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
function apply_patch()
{
  if [ -f ../$PATCH ]; then
    patch -d ${SOURCEDIR} -p1 -i ../../${PATCH}
  fi
}

# TODO 在 SOURCEDIR 下构建
function build()
{
  :
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
  apply_patch
  cd $SOURCEDIR

  build
  package
  if [ "$UPLOAD_ARCHIVE" == 'true' ]; then
    upload
  fi
}

main
