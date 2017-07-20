/*
cd D:\workspaces\Github\CentOS6-Base\resource\conf-hive\metastore-mysql
mysql -uroot -hlocalhost -p111111
source re-create.sql
*/

DROP DATABASE IF EXISTS metastore;
CREATE DATABASE metastore;
USE metastore;

SET autocommit=0;
SOURCE hive-schema-1.1.0.mysql.sql

COMMIT;