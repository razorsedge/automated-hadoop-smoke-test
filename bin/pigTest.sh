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

echo "PIG_PATH_IN: $PIG_PATH_IN"
echo "PIG_PATH_OUT: $PIG_PATH_OUT"

hdfs dfs -mkdir -p "$PIG_PATH_IN"
hdfs dfs -mkdir -p "$PIG_PATH_OUT"

hdfs dfs -put -f ./lib/data.csv "$PIG_PATH_IN"
rc=$?; if [[ $rc != 0 ]]; then echo "Input data transfer failed! exiting"; echo " - Pig          - Failed [Input data transfer failed]" >> "$LOG_PATH"/SummaryReport.txt; exit $rc; fi


if   hdfs dfs -test -e "$PIG_PATH_OUT" ; then
	hdfs dfs -rm -r  "$PIG_PATH_OUT"
	rc=$?; if [[ $rc != 0 ]]; then echo "Cannot remove existing HDFS output directory! exiting"; echo " - Pig          - Failed [Cannot remove existing HDFS output directory]" >> "$LOG_PATH"/SummaryReport.txt; exit $rc; fi
fi

pig -f ./lib/pigScript.pig -param input="$PIG_PATH_IN" -param output="$PIG_PATH_OUT"
rc=$?; if [[ $rc != 0 ]]; then echo "Pig script failed! exiting"; echo " - Pig          - Failed [Pig script failed]" >> "$LOG_PATH"/SummaryReport.txt; exit $rc; fi

echo "************************************"
echo "* Pig test completed Successfully! *"
echo "************************************"

echo " - Pig          - Passed " >> "$LOG_PATH"/SummaryReport.txt

