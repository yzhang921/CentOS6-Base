#!/bin/bash

curDir=$(cd `dirname $0`; pwd)
cd $curDir

myhost="10.32.82.137 myhost"

function display_usage() {
cat << EOF
  usage: $0 -m|-mode=[run|start|stop] -i|-image=[image name] -h|--hlep
    -mode   -m   run mode
    -image  -i   image name, default name is "run-master"
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
    -h | --help)
       display_usage
       exit 1
       ;;
    -m | -mode)
        mode=${value}
        echo "set [mode] to ${value}"
        ;;
    -i | -image)
        image=${value}
        echo "set [image] to ${value}"
        ;;
    * )
        echo "[ERROR]: $key is an unknown parameter."
        display_usage
        exit 1 ;;
  esac
  shift       # Check next set of parameters.
done

if [ "$image" = "" ]; then
   image="centos6-druid"
fi

if [ "$mode" = "" ]; then
   display_usage
   exit 1
fi


function checkAndStart() {
  c_name=$1
  container_id=`docker ps -a -q --filter "name=${c_name}"`
  if [ "$container_id" != "" ]; then
    echo "[INFO] Find container ${c_name} with id ${container_id}, start..."
    sudo docker start ${container_id}
  else
    echo "[WARN] NO container with ${c_name}, try to run new one..."
    $2
  fi
}

# ======================================================================================================================================
# start ruid-coordinator and overload / container
MASTER_NAME="druid-coord"

function run-master() {
  sudo docker rm -f ${MASTER_NAME} &> /dev/null
  echo "[INFO] Run ${MASTER_NAME} container..."
  sudo docker run --name=${MASTER_NAME} \
      -itd \
      --hostname=${MASTER_NAME} \
      --network=hadoop \
      --add-host="${myhost}" \
      -p 8081:8081  \
      ${image}
  # 8081: Coordinator
}

if [ "$mode" = "run" ]; then
  run-master
elif [ "$mode" = "start" ]; then
  checkAndStart ${MASTER_NAME} "run-master"
elif [ "$mode" = "stop" ]; then
  echo "[INFO] stop ${MASTER_NAME} container..."
  sudo docker stop ${MASTER_NAME}
fi


# ======================================================================================================================================
# start Historicals and MiddleManagers container
# the default node number is 2
N=2
function run-slave() {
  sudo docker rm -f ${SLAVE_NAME} &> /dev/null
  echo "[INFO] Run ${SLAVE_NAME} container..."
  sudo docker run --name=${SLAVE_NAME} \
      -itd \
      --hostname=${SLAVE_NAME} \
      --network=hadoop \
      --add-host="${myhost}" \
      ${image}
}

function process-slaves(){
  COMPONENT=$1
  if [ "$mode" = "run" ]; then
  i=1
  while [ $i -le $N ]; do
    SLAVE_NAME=${COMPONENT}$i
    run-slave
    i=$(( $i + 1 ))
  done
elif [ "$mode" = "start" ]; then
  i=1
  while [ $i -le $N ]
  do
    SLAVE_NAME=${COMPONENT}$i
    echo "[INFO] start ${SLAVE_NAME} container..."
    checkAndStart ${SLAVE_NAME} "run-slave"
    i=$(( $i + 1 ))
  done
elif [ "$mode" = "stop" ]; then
  i=1
  while [ $i -le $N ]
  do
    SLAVE_NAME=${COMPONENT}$i
    echo "[INFO] stop ${SLAVE_NAME} container..."
    sudo docker stop ${SLAVE_NAME}
    i=$(( $i + 1 ))
  done
fi
}

process-slaves druid-histor


# ======================================================================================================================================
# start broker

BROKER_NAME="druid-broker"
function run-druid-broker(){
  sudo docker rm -f ${BROKER_NAME} &> /dev/null
  echo "start ${BROKER_NAME} container..."
  sudo docker run --name=${BROKER_NAME} \
      -itd \
      --hostname=${BROKER_NAME} \
      --network=hadoop \
      -p 8082:8082 \
      --add-host="${myhost}" \
      ${image}
}

if [ "$mode" = "run" ]; then
  run-druid-broker
elif [ "$mode" = "start" ]; then
  checkAndStart ${BROKER_NAME} "run-hive-server2"
elif [ "$mode" = "stop" ]; then
  echo "stop ${BROKER_NAME} container..."
  sudo docker stop ${BROKER_NAME}
fi

docker attach ${MASTER_NAME}