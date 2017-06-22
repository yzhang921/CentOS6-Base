#!/bin/bash

# this start zk script is run at each zk container, ususally call my master start-zk-daemons at master
curDir=$(cd `dirname $0`; pwd)
cd $curDir


myid=`hostname | grep -oP '\d'`
rm -rf /var/lib/zookeeper/*
echo ${myid} > /var/lib/zookeeper/myid
cat /var/lib/zookeeper/myid
service zookeeper-server init --myid=${myid}
service zookeeper-server start