#!/bin/bash

su - hdfs -c "hadoop fs -mkdir /hbase"
su - hdfs -c "hadoop fs -chown hbase /hbase"


service hbase-master start
pssh -h slaves -i "service hbase-regionserver start"