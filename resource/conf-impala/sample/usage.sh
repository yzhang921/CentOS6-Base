#!/bin/bash
curDir=$(cd `dirname $0`; pwd)
cd ${curDir}

# arg0: count of sample
# arg1: max value
# arg2: sep
python multicols.py 10000000 99999 comma > billion_rows.csv

hdfs dfs -put billion_rows.csv /user/hive/warehouse/oreilly.db/sample_data;

cat -n usa_cities.lst | sed -e 's/\t/,/' | sed -e 's/^ *//' | tee usa_cities.csv