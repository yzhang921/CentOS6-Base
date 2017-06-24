#!/bin/bash

function display_usage() {
cat << EOF
  usage: $0 --init/--start/--stop/--restart
    init      initialize new cluster environment
    start     start an existing cluster
    stop      stop cluster
    restart   restart cluster
EOF
}

if [ "$#" = 0 ]; then
    display_usage
fi

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
    --start)
        start=y
        echo "set [start] to y"
        ;;
    --stop)
        stop=y
        echo "set [stop] to y"
        ;;
    --restart)
        init=y
        echo "set [restart] to y"
        ;;
    * )
        echo "[ERROR]: $key is an unknown parameter."
        display_usage
        exit 1 ;;
  esac
  shift       # Check next set of parameters.
done


echo "init = ${init}"
echo "stop = ${stop}"
echo "start = ${start}"
echo "restart = ${restart}"
