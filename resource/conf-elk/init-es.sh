#!/bin/bash

node=$1

local_ip=`ifconfig eth0 |grep "inet addr"| cut -f 2 -d ":"|cut -f 1 -d " "`
hostname=`hostname`

echo "network.host: ${local_ip}" >> /etc/elasticsearch/elasticsearch.yml

# [ERROR][o.e.b.Bootstrap          ] [es-master] node validation exception
# [1] bootstrap checks failed
# [1]: max number of threads [1024] for user [elasticsearch] is too low, increase to at least [2048]
echo "\
root                 soft    nproc           2048
root                 hard    nproc           2048
elasticsearch        soft    nproc           2048
relasticsearch       hard    nproc           2048
" >> /etc/security/limits.conf


# ####################################
#
# Coordinator configuration
#


coord_config="
node.master: false
node.data: false
node.ingest: false
transport.host: ${local_ip}
"

if [ "${hostname}" = "es-master" ]; then
  echo "${coord_config}" >> /etc/elasticsearch/elasticsearch.yml
fi



