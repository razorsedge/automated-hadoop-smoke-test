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

echo "SOLR_COLLECTION_NAME: $SOLR_COLLECTION_NAME"
echo "SOLR_INSTANTDIR_NAME: $SOLR_INSTANTDIR_NAME"

solrctl collection --delete "$SOLR_COLLECTION_NAME"
#rc=$?; if [[ $rc != 0 ]]; then echo "error! exiting"; exit $rc; fi

solrctl instancedir --delete "$SOLR_INSTANTDIR_NAME"
#rc=$?; if [[ $rc != 0 ]]; then echo "error! exiting"; exit $rc; fi

rm -rf /tmp/"$SOLR_INSTANTDIR_NAME".$$
#rc=$?; if [[ $rc != 0 ]]; then echo "error! exiting"; exit $rc; fi

