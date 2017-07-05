#!/bin/bash
curDir=$(cd `dirname $0`; pwd)
cd $curDir

source ../parser-params.sh

function start_elasticsearch() {
    echo "[INFO] Start elasticsearch ..."
    echo "[INFO] Start Coordinator.."
    service elasticsearch start
    service kibana start
    pssh -h nodes -i "ES_JAVA_OPTS='-Xms256 -Xmx1g'; service elasticsearch start" | grep -v "Permanently added"
}

function stop_elasticsearch() {
    echo "[INFO] Stop elasticsearch ..."
    echo "[INFO] Stop Coordinator.."
    service elasticsearch stop
    service kibana stop
    pssh -h nodes -i "service elasticsearch stop" | grep -v "Permanently added"
}

if [ "$init" = "y" ]; then
    echo "[INFO] Initialize elasticsearch ..."
    echo "[INFO] Configure coordinator.."
    pssh -v -H "es-master" -i "conf-elk/init-es.sh master" | grep -v "Permanently added"
    pssh -v -h nodes -i "conf-elk/init-es.sh" | grep -v "Permanently added"
fi

if [ "$start" = "y" ]; then
    start_elasticsearch
fi

if [ "$stop" = "y" ]; then
    stop_elasticsearch
fi

if [ "$restart" = "y" ]; then
    echo "[INFO] Restart elasticsearch ..."
    stop_elasticsearch
    start_elasticsearch
fi