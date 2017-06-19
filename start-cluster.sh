#!/bin/bash

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
    --privileged=true \
    centos6-cdh-cmd


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
        centos6-cdh-cmd
    i=$(( $i + 1 ))
done

# get into hadoop master container
sudo docker attach ${MASTER_NAME}