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

if [ -z "$HDFS" ]; then
  # shellcheck disable=SC2128
  if [[ $BASH_SOURCE = */* ]]; then
    cd -- "${BASH_SOURCE%/*}/" || exit
  fi
  # shellcheck source=/dev/null
  source ../conf/SmokeConfig.config
fi

echo "HBASE_TABLE_NAME: $HBASE_TABLE_NAME"

printf "create '%s', 'cf'\n" "$HBASE_TABLE_NAME" | hbase shell -n 2>&1 | grep -q "Hbase::Table - ${HBASE_TABLE_NAME}" 2>/dev/null
rc=$?
if [[ $rc != 0 ]]; then
  echo "Create command failed! exiting"
  echo " - HBase        - Failed [Create command failed]" >> "$LOG_PATH"/SummaryReport.txt
  exit $rc
fi
echo "HBase ${HBASE_TABLE_NAME} table created !"

CMD=$(printf "list '%s'\n" "$HBASE_TABLE_NAME" | hbase shell -n 2>&1)
echo "$CMD"
echo "$CMD" | grep -q "[\"${HBASE_TABLE_NAME}\"]" 2>/dev/null
rc=$?
if [[ $rc != 0 ]]; then
  echo "List command failed! exiting"
  echo " - HBase        - Failed [List command failed]" >> "$LOG_PATH"/SummaryReport.txt
  exit $rc
fi

printf "put '%s', 'row1', 'cf:a', 'value1'\n" "$HBASE_TABLE_NAME" | hbase shell -n 2>&1 | grep -q "ERROR: " 2>/dev/null
rc=$?
if [[ $rc == 0 ]]; then
  echo "Put command failed! exiting"
  echo " - HBase        - Failed [Put command failed]" >> "$LOG_PATH"/SummaryReport.txt
  exit $rc
fi
echo "HBase ${HBASE_TABLE_NAME} data written !"

CMD=$(printf "scan '%s'\n" "$HBASE_TABLE_NAME" | hbase shell -n 2>&1)
echo "$CMD"
echo "$CMD" | grep -q "1 row(s)" 2>/dev/null
rc=$?
if [[ $rc != 0 ]]; then
  echo "Scan command failed! exiting"
  echo " - HBase        - Failed [Scan command failed]" >> "$LOG_PATH"/SummaryReport.txt
  exit $rc
fi

echo "**************************************"
echo "* HBase test completed Successfully! *"
echo "**************************************"
echo " - HBase        - Passed" >> "$LOG_PATH"/SummaryReport.txt

