#!/bin/bash

# Run this shell in master node
# This shell is used to start namenode, datanode

su - hdfs -c "hdfs namenode -format"
service hadoop-hdfs-namenode start
pssh -h slaves -i "service hadoop-hdfs-datanode start"

# Add root to superusergroup of hdfs
usermod -a -G hadoop root
hdfs dfs -mkdir /root
hdfs dfs -put /root/cdh-conf /root


service hadoop-yarn-resourcemanager start
pssh -h slaves -i "service hadoop-yarn-nodemanager start"