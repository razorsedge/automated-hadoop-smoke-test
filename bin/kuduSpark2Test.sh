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

echo "KUDU_MASTER: $KUDU_MASTER"
echo "KUDU_SPARK2_JAR: $KUDU_SPARK2_JAR"
echo "KUDU_SPARK2_TABLE_NAME: $KUDU_SPARK2_TABLE_NAME"

spark2-shell -i ./lib/kudu-spark2.scala --master yarn --jars "$KUDU_SPARK2_JAR" --conf spark.driver.args="$KUDU_MASTER $KUDU_SPARK2_TABLE_NAME"
rc=$?; if [[ $rc != 0 ]]; then echo "Kudu Spark2 Test failed! Exiting!";  echo " - Kudu-Spark2  - Failed [Check log file]" >> "$LOG_PATH"/SummaryReport.txt; exit $rc; fi

echo "********************************************"
echo "* Kudu-Spark2 test completed Successfully! *"
echo "********************************************"

echo " - Kudu-Spark2  - Passed" >> "$LOG_PATH"/SummaryReport.txt

