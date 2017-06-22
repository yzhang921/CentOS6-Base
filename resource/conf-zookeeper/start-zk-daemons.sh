#!/bin/bash

init=$1

curDir=$(cd `dirname $0`; pwd)
cd $curDir

pssh -v -h zk-nodes -i "conf-zookeeper/start-zk.sh ${init}"
