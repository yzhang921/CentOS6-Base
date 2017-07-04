#!/bin/bash
curDir=$(cd `dirname $0`; pwd)
cd $curDir

source ../parser-params.sh

function start_elasticsearch() {
    echo "[INFO] Start elasticsearch ..."
    pssh -h nodes -i "service elasticsearch start" | grep -v "Permanently added"
}

function stop_elasticsearch() {
    echo "[INFO] Stop elasticsearch ..."
    pssh -h nodes -i "service elasticsearch stop" | grep -v "Permanently added"
}

if [ "$init" = "y" ]; then
    echo "[INFO] Initialize elasticsearch ..."
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