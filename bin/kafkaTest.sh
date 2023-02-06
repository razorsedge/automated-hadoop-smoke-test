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

echo "KAFKA_ZOOKEEPER_QUORUM: $KAFKA_ZOOKEEPER_QUORUM"
echo "KAFKA_HOST: $KAFKA_HOST"
echo "TOPIC_NAME: $TOPIC_NAME"
echo "KAFKA_INP_LOC: $KAFKA_INP_LOC"
echo "KAFKA_OUP_LOC: $KAFKA_OUP_LOC"

export KAFKA_OPTS="-Dlog4j.configuration=file:./conf/tools-log4j.properties $KAFKA_OPTS"
#export KAFKA_OPTS="-Djava.security.auth.login.config=./conf/jaas-client.conf $KAFKA_OPTS"

echo "Here creates the topic...!!!"
_KAFKA_TOPIC_OPTS="--command-config=./conf/kafka.conf-${KAFKA_SECURITY_TYPE}"
#kafka-topics  --zookeeper "$KAFKA_ZOOKEEPER_QUORUM" --create --topic "$TOPIC_NAME" --partitions 1 --replication-factor 1
kafka-topics "$_KAFKA_TOPIC_OPTS" --bootstrap-server "$KAFKA_HOST" --create --topic "$TOPIC_NAME" --partitions 1 --replication-factor 1
rc=$?
if [[ $rc != 0 ]]; then
  echo "Cannot create Topic! exiting"
  echo " - Kafka	- Failed [Cannot create Topic]" >> "$LOG_PATH"/SummaryReport.txt
  exit $rc
fi

echo "Here starts the producer...!!!"
#echo "$KAFKA_OUP_LOC" "$KAFKA_INP_LOC"
_KAFKA_PRODUCER_OPTS="--producer.config=./conf/kafka.conf-${KAFKA_SECURITY_TYPE}"
kafka-console-producer "$_KAFKA_PRODUCER_OPTS" --broker-list "$KAFKA_HOST" --topic "$TOPIC_NAME" < "$KAFKA_INP_LOC"
rc=$?
echo "exitcode: $rc"
if [[ ($rc != 0) && ($rc != 130) ]]; then
  echo "Cannot produce data! exiting"
  echo " - Kafka		- Failed [Cannot produce data]" >> "$LOG_PATH"/SummaryReport.txt
  exit $rc
fi

echo "Here starts the consumer...!!!"
_KAFKA_CONSUMER_OPTS="--consumer.config=./conf/kafka.conf-${KAFKA_SECURITY_TYPE}"
kafka-console-consumer "$_KAFKA_CONSUMER_OPTS" --bootstrap-server "$KAFKA_HOST" --topic "$TOPIC_NAME" --from-beginning --timeout-ms 5000 > "$KAFKA_OUP_LOC"
rc=$?
if [[ ($rc != 0) && ($rc != 130) ]]; then
  echo "Cannot consume data! exiting"
  echo " - Kafka		- Failed [Cannot consume data]" >> "$LOG_PATH"/SummaryReport.txt
  exit $rc
fi

if grep -qf "$KAFKA_OUP_LOC" "$KAFKA_INP_LOC"; then
	echo "Same data as produced"
	echo " - Kafka        - Passed" >> "$LOG_PATH"/SummaryReport.txt
	echo "**************************************"
	echo "* Kafka test completed Successfully! *"
	echo "**************************************"
else
	echo "Not same data as produced"
	echo " - Kafka        - Failed [Not Consuming produced data]" >> "$LOG_PATH"/SummaryReport.txt
	echo "**********************"
	echo "* Kafka test Failed! *"
	echo "**********************"
fi

