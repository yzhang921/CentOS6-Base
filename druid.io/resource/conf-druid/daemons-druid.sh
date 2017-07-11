#!/bin/bash

curDir=$(cd `dirname $0`; pwd)
cd $DRUID_HOME


# start coordinator
../druid-sbin/start-coordinator.sh
# start overload
../druid-sbin/start-overload.sh


# start historicals and middleManagers
pssh -h historicals -i "/root/druid-sbin/start-historical.sh" | grep -v "Permanently added"
pssh -h historicals -i "/root/druid-sbin/start-middleManager.sh" | grep -v "Permanently added"


# start broker
ssh root@druid-broker /root/druid-sbin/start-broker.sh