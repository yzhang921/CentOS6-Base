#!/bin/bash

curDir=$(cd `dirname $0`; pwd)
cd $DRUID_HOME


echo "[INFO] Start coordinator..."
../druid-sbin/start-coordinator.sh
echo "[INFO] Start overload..."
../druid-sbin/start-overload.sh


# start historicals and middleManagers
echo "[INFO] Start historicals..."
pssh -h ../druid-sbin/historicals -i "/root/druid-sbin/start-historical.sh" | grep -v "Permanently added"
echo "[INFO] Start middleManagers..."
pssh -h ../druid-sbin/historicals -i "/root/druid-sbin/start-middleManager.sh" | grep -v "Permanently added"


echo "[INFO] Start broker..."
ssh root@druid-broker /root/druid-sbin/start-broker.sh