#!/bin/bash
curDir=$(cd `dirname $0`; pwd)
cd $curDir

function display_usage() {
cat << EOF
  usage: start-hive-daemons.sh [--init]
    init:   add this parameter to initial mysql env, hive metastore
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


mypass=111111

service mysqld start

if [ "$init" = "y" ]; then
  echo "[INFO] Set root password of mysql"
  mysqladmin -u root flush-privileges password ${mypass}
  echo "[INFO] Initial metastore database..."
  cd /usr/lib/hive/scripts/metastore/upgrade/mysql/
  mysql -h localhost -u root -p${mypass} < /root/conf-hive/metastore.sql

  hdfs dfs -mkdir -p /user/hive/warehouse
  hdfs dfs -chown hive /user/hive/warehouse
  hdfs dfs -chmod 777 /user/hive/warehouse
fi

ssh hive "service hive-metastore start; service hive-server2 start"