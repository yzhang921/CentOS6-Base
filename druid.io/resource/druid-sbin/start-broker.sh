#!/bin/bash

curDir=$(cd `dirname $0`; pwd)
source ../druid-sbin/hostnames.sh

cd $DRUID_HOME


java `cat conf/druid/broker/jvm.config | xargs` -cp "conf/druid/_common:conf/druid/broker:lib/*" io.druid.cli.Main server broker \
> /var/log/druid/broker.log 2>&1 &
