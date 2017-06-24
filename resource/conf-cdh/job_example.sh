#!/bin/bash

hadoop jar /usr/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar pi 10 100

hdfs dfs -rm -r -f /tmp/output
hadoop jar /usr/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar wordcount /root/cdh-conf /tmp/output