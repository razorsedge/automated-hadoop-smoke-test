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

echo "PYSPARK_IN_CLUS: $PYSPARK_IN_CLUS"
echo "PYSPARK_OUT_CLUS: $PYSPARK_OUT_CLUS"

hdfs dfs -mkdir -p "$PYSPARK_IN_CLUS"
if hadoop fs -test -d "$SPARK_OUT_CLUS"; then hdfs dfs -rm -r "$SPARK_OUT_CLUS"; fi

echo "this is the end. the only end. my friend." >> pyspark_test.txt
#rc=$?; if [[ $rc != 0 ]]; then echo "Cannot produce input data! exiting"; echo " - pySpark      - Failed [Cannot produce input data]" >> "$LOG_PATH"/SummaryReport.txt; exit $rc; fi

hdfs dfs -put -f pyspark_test.txt "$PYSPARK_IN_CLUS"
rc=$?; if [[ $rc != 0 ]]; then echo "Cannot copy input data! exiting"; echo " - pySpark      - Failed [Cannot copy input data]" >> "$LOG_PATH"/SummaryReport.txt; exit $rc; fi

echo "--- piEstimation ---"
spark-submit ./lib/piEstimation_pyspark.py
rc=$?; if [[ $rc != 0 ]]; then echo "Pi Estimation test failed! exiting"; echo " - pySpark      - Failed [Pi Estimation test failed]" >> "$LOG_PATH"/SummaryReport.txt; exit $rc; fi

echo "--- wordcount ---"
spark-submit ./lib/piEstimation_pyspark.py "$PYSPARK_IN_CLUS" "$PYSPARK_OUT_CLUS"
rc=$?; if [[ $rc != 0 ]]; then echo "Word count test failed! exiting"; echo " - pySpark      - Failed [Word count test failed]" >> "$LOG_PATH"/SummaryReport.txt; exit $rc; fi

echo "****************************************"
echo "* pySpark test completed Successfully! *"
echo "****************************************"

echo " - pySpark      - Passed" >> "$LOG_PATH"/SummaryReport.txt

