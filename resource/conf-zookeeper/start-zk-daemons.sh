#!/bin/bash
curDir=$(cd `dirname $0`; pwd)
cd $curDir

pssh -h zk-nodes -i "echo `hostname | grep -oP '\d'`  >  /var/lib/zookeeper/myid"
pssh -h zk-nodes -i "service zookeeper-server start"
