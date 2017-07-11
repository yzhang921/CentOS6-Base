#!/bin/bash

curDir=$(cd `dirname $0`; pwd)
cd $curDir


cd $DRUID_HOME
source hostnames.sh


java `cat conf/druid/broker/jvm.config | xargs` -cp "conf/druid/_common:conf/druid/broker:lib/*" io.druid.cli.Main server broker \
> /var/log/druid/broker.log 2>&1 &
