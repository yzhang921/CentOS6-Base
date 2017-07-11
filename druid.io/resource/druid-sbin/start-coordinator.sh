#!/bin/bash

curDir=$(cd `dirname $0`; pwd)
cd $DRUID_HOME

# start coordinator
java `cat conf/druid/coordinator/jvm.config | xargs` -cp 'conf/druid/_common:conf/druid/coordinator:lib/*' io.druid.cli.Main server coordinator \
> /var/log/druid/coordinator.log 2>&1 &
