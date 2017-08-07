#!/bin/bash

curDir=$(cd `dirname $0`; pwd)
source ${curDir}/env.sh

cd $DRUID_HOME

# start historical
java `cat conf/druid/historical/jvm.config | xargs` -cp "conf/druid/_common:conf/druid/historical:lib/*" io.druid.cli.Main server historical \
> /var/log/druid/historical.log 2>&1 &
