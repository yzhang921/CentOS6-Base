#!/bin/bash
curDir=$(cd `dirname $0`; pwd)
cd $curDir

unzip -o retail-store-logs-sample-data.zip

hive -v -f "sample_ddl.sql"