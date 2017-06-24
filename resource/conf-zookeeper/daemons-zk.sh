#!/bin/bash
curDir=$(cd `dirname $0`; pwd)
cd $curDir

source ../parser-params.sh

function start_zk() {
    echo "[INFO] Start zk ..."
    pssh -h zk-nodes -i "service zookeeper-server start" | grep -v "Permanently added"
}

function stop_zk() {
    echo "[INFO] Stop zk ..."
    pssh -h zk-nodes -i "service zookeeper-server stop" | grep -v "Permanently added"
}

if [ "$init" = "y" ]; then
    echo "[INFO] Initialize zk ..."
    pssh -v -h zk-nodes -i "conf-zookeeper/init-zk.sh" | grep -v "Permanently added"
fi

if [ "$start" = "y" ]; then
    start_zk
fi

if [ "$stop" = "y" ]; then
    stop_zk
fi

if [ "$restart" = "y" ]; then
    echo "[INFO] Restart zk ..."
    stop_zk
    start_zk
fi