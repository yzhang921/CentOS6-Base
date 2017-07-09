#!/bin/bash

curDir=$(cd `dirname $0`; pwd)
cd $curDir


cd $DRUID_HOME

# start coordinator
java `cat conf/druid/coordinator/jvm.config | xargs` -cp conf/druid/_common:conf/druid/coordinator:lib/* io.druid.cli.Main server coordinator \

# start overload
java `cat conf/druid/overlord/jvm.config | xargs` -cp conf/druid/_common:conf/druid/overlord:lib/* io.druid.cli.Main server overlord \
