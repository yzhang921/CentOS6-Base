#!/bin/bash
curDir=$(cd `dirname $0`; pwd)
cd $curDir


function start_hbase() {
    echo "[INFO] Start HBase ..."
    service hbase-master start
    pssh -h regionservers -i "service hbase-regionserver start" | grep -v "Permanently added"
}

function stop_hbase() {
    echo "[INFO] Stop HBase ..."
    service hbase-master stop
    pssh -h regionservers -i "service hbase-regionserver stop" | grep -v "Permanently added"
}

if [ "$init" = "y" ]; then
    echo "[INFO] Initialize HBase ..."
    hdfs dfs -rm -r -f /hbase
    su - hdfs -c "hadoop fs -mkdir /hbase"
    su - hdfs -c "hadoop fs -chown hbase /hbase"
fi

if [ "$start" = "y" ]; then
    start_hbase
fi

if [ "$stop" = "y" ]; then
    stop_hbase
fi

if [ "$restart" = "y" ]; then
    echo "[INFO] Restart HBase ..."
    stop_hbase
    start_hbase
fi