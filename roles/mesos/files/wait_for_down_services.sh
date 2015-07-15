#!/bin/sh

SERVICE_DOWN_DISCOVERY_DIR=$1
SERVICE_ID=$2
SERVICE_VALUE=$3

echo "waiting for down services to startup..."

DOWN_SERVICES=`/usr/bin/etcdctl ls ${SERVICE_DOWN_DISCOVERY_DIR}`

echo ${DOWN_SERVICES}
echo "---"
echo ${DOWN_SERVICES} | cut -d ' ' -f 1

until test -z "${DOWN_SERVICES}"
do
  echo ${DOWN_SERVICES}
  SERVICE_WE_WAIT_FOR=`echo ${DOWN_SERVICES} | cut -d ' ' -f 1`
  echo ${SERVICE_WE_WAIT_FOR}
  /usr/bin/etcdctl watch "${SERVICE_WE_WAIT_FOR}"
  DOWN_SERVICES=`/usr/bin/etcdctl ls ${SERVICE_DOWN_DISCOVERY_DIR}`
done

echo "going down myself..."
/usr/bin/etcdctl set ${SERVICE_DOWN_DISCOVERY_DIR}/$SERVICE_ID $SERVICE_VALUE
