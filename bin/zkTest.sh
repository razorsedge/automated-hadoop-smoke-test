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

#echo "ZOOKEEPER_QUORUM: $ZOOKEEPER_QUORUM"
#
#cat <<EOF >/tmp/zk.$$
#create /zk_test my_data
#ls /
#get /zk_test
#set /zk_test junk
#get /zk_test
#quit
#EOF
#
#cat /tmp/zk.$$ | zookeeper-client -server $ZOOKEEPER_QUORUM
#
#exit
echo "ZOOKEEPER_QUORUM: $ZOOKEEPER_QUORUM"
echo "ZOOKEEPER_QUORUM_PATH: $ZOOKEEPER_QUORUM_PATH"

export ZOO_LOG4J_PROP="ERROR,CONSOLE"

printf "ls /\n" | zookeeper-client -server "$ZOOKEEPER_QUORUM"
rc=$?
echo
if [[ $rc != 0 ]]; then
  echo "Error listing znodes in ZooKeeper! exiting"
  echo " - ZooKeeper    - Failed [Error listing znodes in ZooKeeper]" >> "$LOG_PATH"/SummaryReport.txt
  exit $rc
fi

printf "create %s my_data\n" "$ZOOKEEPER_QUORUM_PATH" | zookeeper-client -server "$ZOOKEEPER_QUORUM"
rc=$?
echo
if [[ $rc != 0 ]]; then
  echo "Error creating znode in ZooKeeper! exiting"
  echo " - ZooKeeper    - Failed [Error creating znode in ZooKeeper]" >> "$LOG_PATH"/SummaryReport.txt
  exit $rc
fi

printf "sync /\nget %s\n" "$ZOOKEEPER_QUORUM_PATH" | zookeeper-client -server "$ZOOKEEPER_QUORUM"
rc=$?
echo
if [[ $rc != 0 ]]; then
  echo "Error getting znode in ZooKeeper! exiting"
  echo " - ZooKeeper    - Failed [Error getting znode in ZooKeeper]" >> "$LOG_PATH"/SummaryReport.txt
  exit $rc
fi

printf "set %s junk\n" "$ZOOKEEPER_QUORUM_PATH" | zookeeper-client -server "$ZOOKEEPER_QUORUM"
rc=$?
echo
if [[ $rc != 0 ]]; then
  echo "Error setting znode in ZooKeeper! exiting"
  echo " - ZooKeeper    - Failed [Error setting znode in ZooKeeper]" >> "$LOG_PATH"/SummaryReport.txt
  exit $rc
fi

printf "sync /\nget %s\n" "$ZOOKEEPER_QUORUM_PATH" | zookeeper-client -server "$ZOOKEEPER_QUORUM"
rc=$?
echo
if [[ $rc != 0 ]]; then
  echo "Error getting updated znode in ZooKeeper! exiting"
  echo " - ZooKeeper    - Failed [Error getting updated znode in ZooKeeper]" >> "$LOG_PATH"/SummaryReport.txt
  exit $rc
fi

echo "******************************************"
echo "* ZooKeeper test completed Successfully! *"
echo "******************************************"
echo " - ZooKeeper    - Passed" >> "$LOG_PATH"/SummaryReport.txt

#echo "**************************"
#echo "* ZooKeeper test Failed! *"
#echo "**************************"
#echo " - ZooKeeper    - Failed" >> "$LOG_PATH"/SummaryReport.txt

