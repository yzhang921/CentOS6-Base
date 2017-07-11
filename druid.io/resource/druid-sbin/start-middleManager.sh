#!/bin/bash

curDir=$(cd `dirname $0`; pwd)
source ${curDir}/env.sh

cd $DRUID_HOME

# start middleManager
java `cat conf/druid/middleManager/jvm.config | xargs` -cp "conf/druid/_common:conf/druid/middleManager:lib/*" io.druid.cli.Main server middleManager \
> /var/log/druid/middleManager.log 2>&1 &
