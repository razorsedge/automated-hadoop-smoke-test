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

echo "ZOOKEEPER_QUORUM: $ZOOKEEPER_QUORUM"
echo "ZOOKEEPER_QUORUM_PATH: $ZOOKEEPER_QUORUM_PATH"

#cat <<EOF >/tmp/zk-rm.$$
#delete /zk_test
#quit
#EOF
#cat /tmp/zk-rm.$$ | zookeeper-client -server $ZOOKEEPER_QUORUM
#rm -f /tmp/zk.$$ /tmp/zk-rm.$$

export ZOO_LOG4J_PROP="ERROR,CONSOLE"

printf "sync\ndelete %s\n" "$ZOOKEEPER_QUORUM_PATH" | zookeeper-client -server "$ZOOKEEPER_QUORUM"
rc=$?
echo
if [[ $rc != 0 ]]; then
  echo "Error in deleting znode in ZooKeeper!"
  #echo "Error in deleting znode in ZooKeeper! exiting"
  #echo " - ZooKeeper    - Failed [Error in deleting znode in ZooKeeper]" >> "$LOG_PATH"/SummaryReport.txt
  #exit $rc
fi

