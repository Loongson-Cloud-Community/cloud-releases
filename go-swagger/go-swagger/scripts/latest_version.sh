#!/usr/bin/bash

ORG='go-swagger'
PROJECT='go-swagger'


GITHUB_LATEST_API="https://api.github.com/repos/${ORG}/${PROJECT}/releases/latest"

function github_latest_version()
{
  latest_version=$(curl -s -X GET $GITHUB_LATEST_API | grep -o '"tag_name": "[^"]*"' | sed 's/"tag_name": //' | sed 's/"//g')

  echo $latest_version
}


## TODO set latest_function
latest_function=github_latest_version

$latest_function
