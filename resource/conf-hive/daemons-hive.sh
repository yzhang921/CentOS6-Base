#!/bin/bash
curDir=$(cd `dirname $0`; pwd)
cd $curDir

source ../parser-params.sh

function start_hive() {
    echo "[INFO] Start hive ..."
    ssh root@hive-server2 service hive-metastore start | grep -v "Permanently added"
    ssh root@hive-server2 service hive-server2 start | grep -v "Permanently added"
}

function stop_hive() {
    echo "[INFO] Stop hive ..."
    ssh root@hive-server2 service hive-metastore stop | grep -v "Permanently added"
    ssh root@hive-server2 service hive-server2 stop | grep -v "Permanently added"
}

if [ "$init" = "y" ]; then
    echo "[INFO] Initialize hive ..."
    hdfs_path=/user/hive/warehouse
    hdfs dfs -rm -r -f ${hdfs_path}
    hdfs dfs -mkdir -p ${hdfs_path}
    hdfs dfs -chown hive ${hdfs_path}
    hdfs dfs -chmod 777 ${hdfs_path}
fi

if [ "$start" = "y" ]; then
    start_hive
fi

if [ "$stop" = "y" ]; then
    stop_hive
fi

if [ "$restart" = "y" ]; then
    echo "[INFO] Restart hive ..."
    stop_hive
    start_hive
fi