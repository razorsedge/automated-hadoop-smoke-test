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
if [ -z "$HDFS" ]; then
  # shellcheck disable=SC2128
  if [[ $BASH_SOURCE == */* ]]; then
    cd -- "${BASH_SOURCE%/*}/" || exit
  fi
  # shellcheck source=/dev/null
  source ../conf/SmokeConfig.config
fi

echo "HDFS_PATH: $HDFS_PATH"
echo "LOC_PATH: $LOC_PATH"
echo "TEMP_PATH: $TEMP_PATH"

if [[ $_ACTION == "all" ]] || [[ $_ACTION == "test" ]]; then
  hdfs dfs -ls /
  rc=$?
  if [[ $rc != 0 ]]; then
    echo "Error in showing files in HDFS! exiting"
    echo " - HDFS         - Failed [Error in showing files in HDFS]" >>"$LOG_PATH"/SummaryReport.txt
    exit $rc
  fi

  hdfs dfs -mkdir -p "$HDFS_PATH"
  rc=$?
  if [[ $rc != 0 ]]; then
    echo "Error in showing files in HDFS! exiting"
    echo " - HDFS         - Failed [Error in showing files in HDFS]" >>"$LOG_PATH"/SummaryReport.txt
    exit $rc
  fi

  hdfs dfs -put "$LOC_PATH" "$HDFS_PATH"
  rc=$?
  if [[ $rc != 0 ]]; then
    echo "Error in copying file to HDFS! exiting"
    echo " - HDFS         - Failed [Error in copying file to HDFS]" >>"$LOG_PATH"/SummaryReport.txt
    exit $rc
  fi

  hdfs dfs -get "$HDFS_PATH" "$TEMP_PATH"
  rc=$?
  if [[ $rc != 0 ]]; then
    echo "Error in copying file from HDFS! exiting"
    echo " - HDFS         - Failed [Error in copying file from HDFS]" >>"$LOG_PATH"/SummaryReport.txt
    exit $rc
  fi

  cat "$TEMP_PATH"/hosts
  rc=$?
  if [[ $rc != 0 ]]; then
    echo "Error in showing copied file from HDFS! exiting"
    echo " - HDFS         - Failed [Error in showing copied file from HDFS]" >>"$LOG_PATH"/SummaryReport.txt
    exit $rc
  fi

  cmp "$LOC_PATH" "$TEMP_PATH"/"${LOC_PATH##/*/}"
  status=$?
  if [[ $status == 0 ]]; then
    echo "Files are the same"
    echo " - HDFS         - Passed" >>"$LOG_PATH"/SummaryReport.txt
    echo "**************************************"
    echo "* HDFS test completed Successfully ! *"
    echo "**************************************"
  else
    echo "Files are different"
    echo " - HDFS         - Failed[Files are different]" >>"$LOG_PATH"/SummaryReport.txt
    echo "**********************"
    echo "* HDFS test Failed ! *"
    echo "**********************"
  fi
elif [[ $_ACTION == "all" ]] || [[ $_ACTION == "clean" ]]; then
  hdfs dfs -rm -r "$HDFS_PATH"
  rm -f -r "$TEMP_PATH"
fi
