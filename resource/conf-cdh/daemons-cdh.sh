#!/bin/bash

curDir=$(cd `dirname $0`; pwd)
cd $curDir

source ../parser-params.sh


function init_cdh() {
  echo "[INFO] Start initial hdfs cluster"

  echo "[INFO] Format hdfs..."
  su - hdfs -c "hdfs namenode -format"

  echo "[INFO] Add root to superuser group of hdfs"
  usermod -a -G hadoop root

  echo "[INFO] mkdir /root and put cdh-conf to hdfs"
  hdfs dfs -mkdir /root
  hdfs dfs -put /root/cdh-conf /root
}

function start_cdh() {
  echo "[INFO] Start hdfs cluster"
  service hadoop-hdfs-namenode start
  pssh -h slaves -i "service hadoop-hdfs-datanode start"

  echo "[INFO] Start yarn cluster"
  service hadoop-yarn-resourcemanager start
  pssh -h slaves -i "service hadoop-yarn-nodemanager start"
}

function stop_cdh() {
  echo "[INFO] Stop hdfs cluster"
  service hadoop-hdfs-namenode stop
  pssh -h slaves -i "service hadoop-hdfs-datanode start"

  echo "[INFO] Stop yarn cluster"
  service hadoop-yarn-resourcemanager stop
  pssh -h slaves -i "service hadoop-yarn-nodemanager start"
}

if [ "$init" = "y" ]; then
    init_cdh
fi

if [ "$start" = "y" ]; then
    start_cdh
fi

if [ "$stop" = "y" ]; then
    stop_cdh
fi

if [ "$restart" = "y" ]; then
    stop_cdh
fi