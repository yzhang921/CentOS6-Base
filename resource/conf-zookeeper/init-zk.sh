#!/bin/bash

# this start zk script is run at each zk container, usually call my master start-zk-daemons at master
curDir=$(cd `dirname $0`; pwd)
cd $curDir

init=$1

echo "[INFO] Set myid of zk"
myid=`hostname | grep -oP '\d'`
rm -rf /var/lib/zookeeper/*
echo ${myid} > /var/lib/zookeeper/myid
cat /var/lib/zookeeper/myid


echo "[INFO] Start intitail ZK cluster"
service zookeeper-server init --myid=${myid}

