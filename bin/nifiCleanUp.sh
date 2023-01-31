#!/bin/bash
if [ -n "$DEBUG" ]; then set -x; fi

if [ -z "$HDFS" ]; then
  # shellcheck disable=SC2128
  if [[ $BASH_SOURCE = */* ]]; then
    cd -- "${BASH_SOURCE%/*}/" || exit
  fi
  # shellcheck source=/dev/null
  source ../conf/SmokeConfig.config
fi

echo "TEMP_HDFS_DIRECTORY: $TEMP_HDFS_DIRECTORY"

rm -f SmokeTest.xml
hdfs dfs -rm -r -f -skipTrash "$TEMP_HDFS_DIRECTORY"

