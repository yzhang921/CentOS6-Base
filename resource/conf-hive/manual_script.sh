# Manually execute this script at hive-server2 container

@cmd-master
# Add hive user to usergroup of hdfs
usermod -a -G hadoop hive
hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -chown hive /user/hive/warehouse
hdfs dfs -chmod 777 /user/hive/warehouse


ssh hive-server2
# Switch path to use ddl in this folder
service mysqld start
cd /usr/lib/hive/scripts/metastore/upgrade/mysql/
mysql -uroot -p


# Copy  and execute sql in metastore.sql
service hive-metastore start
service hive-server2 start

netstat -anp
# connect to hive-server2 @ any node where hive-client installed
/usr/lib/hive/bin/beeline
beeline> !connect jdbc:hive2://hive-server2:10000
org.apache.hive.jdbc.HiveDriver
0: jdbc:hive2://localhost:10000> SHOW TABLES;
