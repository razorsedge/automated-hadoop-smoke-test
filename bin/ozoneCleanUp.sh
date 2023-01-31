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

ozone fs -rm -r -skipTrash "ofs://${OZONE_SERVICE_ID}/${OZONE_VOLUME}"
rm -f -r "$OZONE_TEMP_PATH"

