#!/bin/bash

curDir=$(cd `dirname $0`; pwd)
cd $curDir


cd $DRUID_HOME
source hostnames.sh

java `cat conf/druid/middleManager/jvm.config | xargs` -cp "conf/druid/_common:conf/druid/middleManager:lib/*" io.druid.cli.Main server middleManager \
> /var/log/druid/middleManager.log 2>&1 &
