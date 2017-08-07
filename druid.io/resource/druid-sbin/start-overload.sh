#!/bin/bash

curDir=$(cd `dirname $0`; pwd)
source ${curDir}/env.sh

cd $DRUID_HOME

# start overload
java `cat conf/druid/overlord/jvm.config | xargs` -cp 'conf/druid/_common:conf/druid/overlord:lib/*' io.druid.cli.Main server overlord \
> /var/log/druid/overlord.log 2>&1 &