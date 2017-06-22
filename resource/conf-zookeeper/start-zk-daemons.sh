#!/bin/bash
curDir=$(cd `dirname $0`; pwd)
cd $curDir

pssh -h zk-nodes -i "echo `hostname | grep -oP '\d'`  >  /var/lib/zookeeper/myid; service zookeeper-server init; service zookeeper-server start"