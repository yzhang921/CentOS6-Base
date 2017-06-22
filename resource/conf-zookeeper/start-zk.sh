#!/bin/bash

curDir=$(cd `dirname $0`; pwd)
cd $curDir

# this start zk script is run at each zk container, ususally call my master start-zk-daemons at master
curDir=$(cd `dirname $0`; pwd)
cd $curDir

init=$1

myid=`hostname | grep -oP '\d'`
rm -rf /var/lib/zookeeper/*
echo ${myid} > /var/lib/zookeeper/myid
cat /var/lib/zookeeper/myid

if [ "$init" = "y" ]; then
  echo "[INFO] Start intitail ZK cluster"
  service zookeeper-server init --myid=${myid}
fi

service zookeeper-server start