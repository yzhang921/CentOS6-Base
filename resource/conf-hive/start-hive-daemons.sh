#!/bin/bash
curDir=$(cd `dirname $0`; pwd)
cd $curDir

mypass=111111

mysqladmin -u root flush-privileges password ${mypass}

cd /usr/lib/hive/scripts/metastore/upgrade/mysql/
mysql -h localhost -u root -p${mypass} < /root/conf-hive/metastore.sql


ssh hive "service hive-metastore start; service hive-server2 start"