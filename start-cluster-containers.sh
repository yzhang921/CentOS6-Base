#!/bin/bash

curDir=$(cd `dirname $0`; pwd)
cd $curDir

image=$1

if [ "$image" = "" ]; then
   image="centos6-cdh-cmd"
fi

# start hadoop master container
MASTER_NAME="cmd-master"
sudo docker rm -f ${MASTER_NAME} &> /dev/null
echo "start hadoop-master container..."
sudo docker run --name=${MASTER_NAME} \
    -itd \
    --hostname=${MASTER_NAME} \
    --network=hadoop \
    -p 50070:50070 \
    -p 8088:8088 \
    -p 60010:60010 \
    --privileged=true \
    ${image}


# start hadoop slave container
# the default node number is 2
N=2
i=1
while [ $i -le $N ]
do
    SLAVE_NAME=cmd-slave$i
    sudo docker rm -f ${SLAVE_NAME} &> /dev/null
    echo "start hadoop-slave$i container..."
    sudo docker run --name=${SLAVE_NAME} \
        -itd \
        --hostname=${SLAVE_NAME} \
        --network=hadoop \
        --privileged=true \
        ${image}
    i=$(( $i + 1 ))
done

# start zookeeper cluster
N=3
i=1
while [ $i -le $N ]
do
    SLAVE_NAME=zk-node$i
    sudo docker rm -f ${SLAVE_NAME} &> /dev/null
    echo "start zk-node$i container..."
    sudo docker run --name=${SLAVE_NAME} \
        -itd \
        --hostname=${SLAVE_NAME} \
        --network=hadoop \
        --privileged=true \
        ${image}
    i=$(( $i + 1 ))
done

# start hive-server2, metastore on this container
MASTER_NAME="hive-server2"
sudo docker rm -f ${MASTER_NAME} &> /dev/null
echo "start ${MASTER_NAME} container..."
sudo docker run --name=${MASTER_NAME} \
    -itd \
    --hostname=${MASTER_NAME} \
    --network=hadoop \
    -p 3306:3306 \
    -p 10002:10002 \
    --privileged=true \
    ${image}

# get into hadoop master container
# sudo docker attach ${MASTER_NAME}