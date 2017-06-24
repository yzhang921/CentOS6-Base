# Manually execute this script at hive-server2 container

# create metadata database
ssh hive-server2
# Switch path to use ddl in this folder
service mysqld start
cd /usr/lib/hive/scripts/metastore/upgrade/mysql/
mysql -uroot -p
# Copy  and execute sql in metastore.sql


conf-hive/daemon-hive.sh --init --start


netstat -anp
# connect to hive-server2 @ any node where hive-client installed
/usr/lib/hive/bin/beeline
beeline> !connect jdbc:hive2://hive-server2:10000
Enter username for jdbc:hive2://hive-server2:10000: root
Enter password for jdbc:hive2://hive-server2:10000: [blank]
0: jdbc:hive2://localhost:10000> SHOW TABLES;
