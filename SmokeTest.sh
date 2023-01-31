#!/bin/bash

if [ -n "$DEBUG" ]; then set -x; fi

# shellcheck disable=SC2128
if [[ $BASH_SOURCE = */* ]]; then
  cd -- "${BASH_SOURCE%/*}/" || exit
fi
# shellcheck source=/dev/null
source conf/SmokeConfig.config

timestamp=$(date '+%Y%m%d%H%M%S')

mkdir -p "$LOG_PATH"
touch "$LOG_PATH"/"$timestamp"logs.log
: >"$LOG_PATH"/SummaryReport.txt

{
echo "*********************************"
echo "Hadoop Automated Smoke Test Suite"
echo "*********************************"

if $KERBEROS_SECURITY; then
	kinit -R
	kinit_succeeded=$?
	if [[ $kinit_succeeded != 0 ]]; then
		echo "Could not renew the ticket granting token (TGT). Please make sure you have obtained a TGT from kerberos. Exiting!"
		exit 1
	else
		echo "Successfully renewed ticket granting token (TGT)."
	fi
	echo "*********************************************************************************"
fi

if $ZOOKEEPER; then
	echo "Smoke test for ZooKeeper"
	bash bin/zkTest.sh
	echo "*********************************************************************************"
fi

if $HDFS; then
	echo "Smoke test for HDFS"
	bash bin/hdfsTest.sh
	echo "*********************************************************************************"
fi

if $MAPREDUCE; then
	echo "Smoke test for MAPREDUCE"
	bash bin/mrTest.sh
	echo "*********************************************************************************"
fi

if $HIVE; then
	echo "Smoke test for HIVE"
	bash bin/hiveTest.sh
	echo "*********************************************************************************"
fi

if $HBASE; then
	echo "Smoke test for HBASE"
	bash bin/hbaseTest.sh
	echo "*********************************************************************************"
fi

if $IMPALA; then
	echo "Smoke test for IMPALA"
	bash bin/impalaTest.sh
	echo "*********************************************************************************"
fi

if $SPARK; then
	echo "Smoke test for SPARK"
	bash bin/sparkTest.sh
	echo "*********************************************************************************"
fi

if $SPARK2; then
	echo "Smoke test for SPARK"
	bash bin/spark2Test.sh
	echo "*********************************************************************************"
fi

if $PYSPARK; then
	echo "Smoke test for PYSPARK"
	bash bin/pysparkTest.sh
	echo "*********************************************************************************"
fi

if $PYSPARK2; then
	echo "Smoke test for PYSPARK2"
	bash bin/pyspark2Test.sh
	echo "*********************************************************************************"
fi

if $PIG; then
	echo "Smoke test for PIG"
	bash bin/pigTest.sh
	echo "*********************************************************************************"
fi

if $SOLR; then
	echo "Smoke test for SOLR"
	bash bin/solrTest.sh
	echo "*********************************************************************************"
fi

if $KAFKA; then
	echo "Smoke test for KAFKA"
	bash bin/kafkaTest.sh
	echo "*********************************************************************************"
fi

if $KUDU; then
	echo "Smoke test for KUDU"
	bash bin/kuduTest.sh
	echo "*********************************************************************************"
fi

if $KUDU_SPARK; then
	echo "Smoke test for KUDU_SPARK"
	bash bin/kuduSpark2Test.sh
	echo "*********************************************************************************"
fi

if $NIFI; then
	echo "Smoke test for NIFI"
	bash bin/nifiTest.sh
	echo "*********************************************************************************"
fi

if $OZONE; then
	echo "Smoke test for OZONE"
	bash bin/ozoneTest.sh
	echo "*********************************************************************************"
fi

echo "Get rid of all the test bits."

if $ZOOKEEPER ; then
	bash bin/zkCleanUp.sh
	echo "*********************************************************************************"
fi

if $HDFS ; then
	hdfs dfs -rm -r "$HDFS_PATH"
	rm -f -r "$TEMP_PATH"
	echo "*********************************************************************************"
fi

if $MAPREDUCE ; then
	hdfs dfs -rm -r "$MAP_REDUCE_IN"/WordCountFile.txt
	hdfs dfs -rm -r "$MAP_REDUCE_OUT"
	echo "*********************************************************************************"
fi

if $HIVE ; then
	bash bin/hiveCleanUp.sh
	echo "*********************************************************************************"
fi

if $HBASE ; then
	bash bin/hbaseCleanUp.sh
	echo "*********************************************************************************"
fi

if $SPARK ; then
	hdfs dfs -rm -r "$SPARK_OUT_CLUS"
	hdfs dfs -rm -r "$SPARK_IN_CLUS"
	rm -f spark_test.txt
	echo "*********************************************************************************"
fi

if $SPARK2 ; then
	hdfs dfs -rm -r "$SPARK_OUT_CLUS"
	hdfs dfs -rm -r "$SPARK_IN_CLUS"
	rm -f spark2_test.txt
	echo "*********************************************************************************"
fi

if $PYSPARK ; then
	hdfs dfs -rm -r "$PYSPARK_OUT_CLUS"
	hdfs dfs -rm -r "$PYSPARK_IN_CLUS"
	rm -f pyspark_test.txt
	echo "*********************************************************************************"
fi

if $PYSPARK2 ; then
	hdfs dfs -rm -r "$PYSPARK_OUT_CLUS"
	hdfs dfs -rm -r "$PYSPARK_IN_CLUS"
	rm -f pyspark2_test.txt
	echo "*********************************************************************************"
fi

if $PIG ; then
	hdfs dfs -rm -r "$PIG_PATH_IN"
	hdfs dfs -rm -r "$PIG_PATH_OUT"
	echo "*********************************************************************************"
fi

if $KAFKA ; then
	bash bin/kafkaCleanUp.sh
	echo "*********************************************************************************"
fi

if $SOLR ; then
	bash bin/solrCleanUp.sh
	echo "*********************************************************************************"
fi

if $IMPALA ; then
	bash bin/impalaCleanUp.sh
	echo "*********************************************************************************"
fi

if $KUDU ; then
	bash bin/kuduCleanUp.sh
	echo "*********************************************************************************"
fi

if $KUDU_SPARK ; then
	echo "*********************************************************************************"
fi

if $NIFI ; then
	bash bin/nifiCleanUp.sh
	echo "*********************************************************************************"
fi

if $OZONE ; then
	bash bin/ozoneCleanUp.sh
	echo "*********************************************************************************"
fi
} 2>&1 | tee -a "$LOG_PATH"/"$timestamp"logs.log

cat "$LOG_PATH"/SummaryReport.txt
mv "$LOG_PATH"/SummaryReport.txt "$LOG_PATH"/"$timestamp"SummaryReport.txt

