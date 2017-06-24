#!/bin/bash
# Run this shell in master node
# This shell is used to start namenode, datanode

curDir=$(cd `dirname $0`; pwd)
cd $curDir

function display_usage() {
cat << EOF
  usage: start-daemons.sh [--init]
    init:   add this parameter to initial hdfs cluster, blank to start existing cluster
EOF
}

init=n

echo "[INFO] Parse all the arguments...."
while [ $# -gt 0 ]; do    # Until you run out of parameters . . .
  key=${1%%=*}  # 从后往前删掉最大匹配的字符得到key
  value=${1#*=} # 从前往后删掉最小匹配的字符得到value
  case "${key}" in
    --help)
       display_usage
       exit 1
       ;;
    --init)
        init=y
        echo "set [init] to y"
        ;;
    * )
        echo "[ERROR]: $key is an unknown parameter."
        display_usage
        exit 1 ;;
  esac
  shift       # Check next set of parameters.
done

echo "init = ${init}"


if [ "$init" = "y" ]; then
  echo "[INFO] Start initial hdfs cluster"
  su - hdfs -c "hdfs namenode -format"
  # Add root to superusergroup of hdfs
  usermod -a -G hadoop root
  hdfs dfs -mkdir /root
  hdfs dfs -put /root/cdh-conf /root
fi


echo "[INFO] Start hdfs cluster"
service hadoop-hdfs-namenode start
pssh -h slaves -i "service hadoop-hdfs-datanode start"

echo "[INFO] Start yarn cluster"
service hadoop-yarn-resourcemanager start
pssh -h slaves -i "service hadoop-yarn-nodemanager start"