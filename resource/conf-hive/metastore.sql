DROP DATABASE IF EXISTS metastore;
CREATE DATABASE metastore;
USE metastore;
SOURCE /usr/lib/hive/scripts/metastore/upgrade/mysql/hive-schema-1.1.0.mysql.sql;

DROP USER hive@localhost;
CREATE USER 'hive'@'localhost' IDENTIFIED BY 'hive';
GRANT ALL PRIVILEGES ON metastore.* TO 'hive'@'localhost';

FLUSH PRIVILEGES;
