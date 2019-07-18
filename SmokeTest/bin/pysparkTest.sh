#!/usr/bin/env bash
source ./conf/SmokeConfig.config

# echo "SPARK_IN_CLUS: $SPARK_IN_CLUS"
# echo "SPARK_OUT_CLUS: $SPARK_OUT_CLUS"

# hdfs dfs -mkdir -p "$SPARK_IN_CLUS"
# hdfs dfs -rm -r "$SPARK_OUT_CLUS"

# echo "this is the end. the only end. my friend." >> spark_test.txt
# rc=$?; if [[ $rc != 0 ]]; then echo "Can not produce input data! exiting"; echo " - Spark	- Failed [Can not produce input data]" >> ./log/SummaryReport.txt; exit $rc; fi

# hdfs dfs -put -f spark_test.txt "$SPARK_IN_CLUS"
# rc=$?; if [[ $rc != 0 ]]; then echo "Can not copy input data! exiting"; echo " - Spark	- Failed [Can not copy input data]" >> ./log/SummaryReport.txt; exit $rc; fi

echo "--- piEstimation ---"
pyspark -i  ./lib/piEstimation.py
rc=$?; if [[ $rc != 0 ]]; then echo "Pi Estimation test failed! exiting"; echo " - Spark	- Failed [Pi Estimation test failed]" >> ./log/SummaryReport.txt; exit $rc; fi

# echo "--- wordcount ---"
# pyspark2 -i ./lib/wordcount.scala --conf spark.driver.args="$SPARK_IN_CLUS" "$SPARK_OUT_CLUS"
# rc=$?; if [[ $rc != 0 ]]; then echo "Word count test failed! exiting"; echo " - Spark	- Failed [Word count test failed]" >> ./log/SummaryReport.txt; exit $rc; fi

echo "**************************************"
echo "* pySpark test completed Successfully! *"
echo "**************************************"

echo " - pySpark	- Passed" >> ./log/SummaryReport.txt