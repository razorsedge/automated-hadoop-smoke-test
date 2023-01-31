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

echo "##########"
echo "IMPALA_SSL_ENABLED: $IMPALA_SSL_ENABLED"
echo "IMPALA_KERBEROS_ENABLED: $IMPALA_KERBEROS_ENABLED"
echo "IMPALA_LDAP_ENABLED: $IMPALA_LDAP_ENABLED"
echo "IMPALA_TABLE_NAME: $IMPALA_TABLE_NAME"

IMPALA_CONNECT_STRING="--impalad=${IMPALA_DAEMON} --database=${IMPALA_DATABASE_NAME}"
if [ "$IMPALA_SSL_ENABLED" == true ]; then
	IMPALA_CONNECT_STRING="${IMPALA_CONNECT_STRING} ${ITOPTS}"
fi
if [ "$IMPALA_KERBEROS_ENABLED" == true ]; then
	IMPALA_CONNECT_STRING="${IMPALA_CONNECT_STRING} ${IKOPTS}"
fi
if [ "$IMPALA_LDAP_ENABLED" == true ]; then
	IMPALA_CONNECT_STRING="${IMPALA_CONNECT_STRING} ${ILOPTS}"
fi
echo "IMPALA_CONNECT_STRING: ${IMPALA_CONNECT_STRING}"
echo "##########"

# shellcheck disable=SC2086
impala-shell $IMPALA_CONNECT_STRING -q "DROP TABLE ${IMPALA_TABLE_NAME};"

rm -f impala_select_test.txt impala_check.txt

