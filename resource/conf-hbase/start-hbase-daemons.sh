#!/bin/bash
curDir=$(cd `dirname $0`; pwd)
cd $curDir

hdfs dfs -rm -r -f /hbase
su - hdfs -c "hadoop fs -mkdir /hbase"
su - hdfs -c "hadoop fs -chown hbase /hbase"

service hbase-master start
pssh -h regionservers -i "service hbase-regionserver start"