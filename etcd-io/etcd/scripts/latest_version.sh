#!/usr/bin/bash

ORG='etcd-io'
PROJECT='etcd'


GITHUB_LATEST_API="https://api.github.com/repos/${ORG}/${PROJECT}/releases/latest"

function github_latest_version()
{
  latest_version=$(curl -s -X GET $GITHUB_LATEST_API | grep -o '"tag_name": "[^"]*"' | sed 's/"tag_name": //' | sed 's/"//g')

  echo $latest_version
}


## TODO set latest_function
latest_function=github_latest_version

$latest_function

# git 获取全部tag
# git ls-remote --tags https://github.com/go-swagger/go-swagger.git | awk '{print $2}' | grep -v '{}' | awk -F '/' '{print $3}'
