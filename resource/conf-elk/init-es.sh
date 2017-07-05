#!/bin/bash

local_ip=`ifconfig eth0 |grep "inet addr"| cut -f 2 -d ":"|cut -f 1 -d " "`
echo "network.host: ${local_ip}" >> /etc/elasticsearch/elasticsearch.yml