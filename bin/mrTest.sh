#!/bin/bash
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Copyright Clairvoyant 2019
#
if [ -n "$DEBUG" ]; then set -x; fi
#

if [ -z "$HDFS" ]; then
  # shellcheck disable=SC2128
  if [[ $BASH_SOURCE = */* ]]; then
    cd -- "${BASH_SOURCE%/*}/" || exit
  fi
  # shellcheck source=/dev/null
  source ../conf/SmokeConfig.config
fi

echo "MAP_REDUCE_IN: $MAP_REDUCE_IN"
echo "MAP_REDUCE_OUT: $MAP_REDUCE_OUT"
echo "MAP_REDUCE_JAR: $MAP_REDUCE_JAR"


hdfs dfs -rm -r -f "$MAP_REDUCE_IN"
hdfs dfs -rm -r -f "$MAP_REDUCE_OUT"

hdfs dfs -mkdir -p "$MAP_REDUCE_IN"
hdfs dfs -mkdir -p "$MAP_REDUCE_OUT"

hdfs dfs -put -f ./lib/WordCountFile.txt "$MAP_REDUCE_IN"/
rc=$?; if [[ $rc != 0 ]]; then echo "Input data tranfser failed! exiting"; echo " - MapReduce    - Failed [Input data tranfser failed]" >> "$LOG_PATH"/SummaryReport.txt; exit $rc; fi

hdfs dfs -rm -r "$MAP_REDUCE_OUT"

yarn jar "$MAP_REDUCE_JAR" wordcount "$MAP_REDUCE_IN"/WordCountFile.txt "$MAP_REDUCE_OUT"
rc=$?; if [[ $rc != 0 ]]; then echo "Mapreduce Job failed! exiting"; echo " - MapReduce    - Failed [Wordcount test failed]" >> "$LOG_PATH"/SummaryReport.txt; exit $rc; fi

echo "******************************************"
echo "* MapReduce test completed Successfully! *"
echo "******************************************"

echo " - MapReduce    - Passed" >> "$LOG_PATH"/SummaryReport.txt

