#!/bin/bash

curDir=$(cd `dirname $0`; pwd)
cd $curDir


cd $DRUID_HOME
source hostnames.sh

# start coordinator
java `cat conf/druid/coordinator/jvm.config | xargs` -cp 'conf/druid/_common:conf/druid/coordinator:lib/*' io.druid.cli.Main server coordinator \
> /var/log/druid/coordinator.log 2>&1 &
