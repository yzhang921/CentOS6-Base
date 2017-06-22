#!/bin/bash

curDir=$(cd `dirname $0`; pwd)
cd $curDir

function display_usage() {
cat << EOF
  usage: start-zk-daemons.sh [--init]
    init:   add this parameter to initial zk cluster, blank to start existing cluster
EOF
}

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

if [ "$init" != "y" ]; then
  init=n
fi

echo "init = ${init}"

#pssh -v -h zk-nodes -i "conf-zookeeper/start-zk.sh ${init}"
