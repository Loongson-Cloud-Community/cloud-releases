#!/bin/bash
set -o errexit
set -o nounset

ORG=$1
PROJECT=$2

INTERNAL="scripts/internal"
NEW_PATH="$ORG/$PROJECT"
mkdir -pv $NEW_PATH
cp -R template/. $NEW_PATH/

pushd $NEW_PATH
sed -i "s/T_ORG/$ORG/g; s/T_PROJECT/$PROJECT/g" scripts/internal/ci.sh
sed -i "s/T_ORG/$ORG/g; s/T_PROJECT/$PROJECT/g" scripts/latest_version.sh
popd
