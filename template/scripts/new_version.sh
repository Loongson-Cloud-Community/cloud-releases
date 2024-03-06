#!/usr/bin/bash

# new_version 0.0.1
new_version() {
  version=$1
  mkdir $version
  cp -r scripts/internal/. $version

  sed -i 's/T_VERSION/'$version'/g' $version/ci.sh
}

new_version $1
