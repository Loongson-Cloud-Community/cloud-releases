#!/bin/bash

set -o errexit
set -o nounset

MAVEN_VERSION=
DOWNLOAD_URL=
MAVEN_MAJOR_VERSION=

lib_path=$(cd $(dirname $0); pwd)

INSTALL_DIR=/usr/local
install_maven()
{
  pushd /tmp

  curl -OL https://archive.apache.org/dist/maven/maven-${MAVEN_MAJOR_VERSION}/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz
  tar -xf apache-maven*.gz && rm -rf *.gz
  mv apache-maven* maven
  cp -Rf maven/. $INSTALL_DIR

  popd
}

# 调用系统检测脚本
source check-devlopment.sh

# 检查系统类型并设置 ABI
A=$(check_system_type; echo $?)


install_loongson_settings()
{
  mkdir -pv ~/.m2
  if [ $A -eq "1" ];then
	cp $lib_path/loongson-maven-abi1.0.xml ~/.m2/settings.xml
  else
	cp $lib_path/loongson-maven-abi2.0.xml ~/.m2/settings.xml
  fi

}

MAVEN_VERSION=$1
MAVEN_MAJOR_VERSION=${MAVEN_VERSION%%.*}

install_maven
install_loongson_settings
