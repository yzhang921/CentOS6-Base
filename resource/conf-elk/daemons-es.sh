#!/bin/bash
curDir=$(cd `dirname $0`; pwd)
cd $curDir

source ../parser-params.sh

function start_elasticsearch() {
    echo "[INFO] Start elasticsearch ..."
    pssh -h nodes -i "ES_JAVA_OPTS='-Xms256 -Xmx1g'; service elasticsearch start" | grep -v "Permanently added"
}

function stop_elasticsearch() {
    echo "[INFO] Stop elasticsearch ..."
    pssh -h nodes -i "service elasticsearch stop" | grep -v "Permanently added"
}

if [ "$init" = "y" ]; then
    echo "[INFO] Initialize elasticsearch ..."
    echo "[INFO] Configure Coordinator.."
    cp -fR /root/conf-elk/es-coordinator.yml /etc/elasticsearch/elasticsearch.yml
    local_ip=`ifconfig eth0 |grep "inet addr"| cut -f 2 -d ":"|cut -f 1 -d " "`
    echo "transport.host: ${local_ip}" >> /etc/elasticsearch/elasticsearch.yml
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