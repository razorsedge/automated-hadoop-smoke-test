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
PATH=/usr/bin:/usr/sbin:/bin:/sbin:/usr/local/bin
_ACTION="all"

# Function to print the help screen.
print_help() {
  echo "Usage:  $1 [-t|-c]"
  echo ""
  echo "        $1 [-t]   # only run test"
  echo "        $1 [-c]   # only run cleanup"
  echo "        $1 [-h]   # help"
  echo ""
  echo "   ex.  $1        # run both test and cleanup"
  exit 1
}

while getopts 'tch' _OPT; do
  case $_OPT in
    t)
      _ACTION="test"
      ;;
    c)
      _ACTION="clean"
      ;;
    h)
      print_help "$(basename "$0")"
      ;;
    *)
      print_help "$(basename "$0")"
      ;;
  esac
done

# main
if [ -z "$MAPREDUCE" ]; then
  # shellcheck disable=SC2128
  if [[ $BASH_SOURCE == */* ]]; then
    cd -- "${BASH_SOURCE%/*}/" || exit
  fi
  # shellcheck source=/dev/null
  source ../conf/SmokeConfig.config
  MAP_REDUCE_SRC=../lib/WordCountFile.txt
else
  MAP_REDUCE_SRC=lib/WordCountFile.txt
fi

echo "MAP_REDUCE_IN: $MAP_REDUCE_IN"
echo "MAP_REDUCE_OUT: $MAP_REDUCE_OUT"
echo "MAP_REDUCE_JAR: $MAP_REDUCE_JAR"

if [[ $_ACTION == "all" ]] || [[ $_ACTION == "test" ]]; then
  hdfs dfs -mkdir -p "$MAP_REDUCE_IN"
  hdfs dfs -put -f "$MAP_REDUCE_SRC" "$MAP_REDUCE_IN"
  rc=$?
  if [[ $rc != 0 ]]; then
    echo "Input data tranfser failed! exiting"
    echo " - MapReduce    - Failed [Input data tranfser failed]" >>"$LOG_PATH"/SummaryReport.txt
    exit $rc
  fi

  yarn jar "$MAP_REDUCE_JAR" wordcount "$MAP_REDUCE_IN"WordCountFile.txt "$MAP_REDUCE_OUT"
  rc=$?
  if [[ $rc != 0 ]]; then
    echo "Mapreduce Job failed! exiting"
    echo " - MapReduce    - Failed [Wordcount test failed]" >>"$LOG_PATH"/SummaryReport.txt
    exit $rc
  fi

  echo " - MapReduce    - Passed" >>"$LOG_PATH"/SummaryReport.txt
  echo "******************************************"
  echo "* MapReduce test completed Successfully! *"
  echo "******************************************"
fi
if [[ $_ACTION == "all" ]] || [[ $_ACTION == "clean" ]]; then
  hdfs dfs -rm -r "$MAP_REDUCE_IN" "$MAP_REDUCE_OUT"
fi
