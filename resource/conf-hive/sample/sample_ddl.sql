DROP DATABASE IF EXISTS omniture CASCADE;
CREATE DATABASE omniture;

USE omniture;
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  swid STRING,
  birth_dt STRING,
  gender_cd CHAR(1)
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY 't'
STORED AS TEXTFILE
TBLPROPERTIES ("skip.header.line.count"="1");


DROP TABLE IF EXISTS products;
CREATE TABLE products (url STRING, category STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY 't'
STORED AS TEXTFILE
TBLPROPERTIES ("skip.header.line.count"="1");

CREATE TABLE omniturelogs (
  col_1 STRING,col_2 STRING,col_3 STRING,col_4 STRING,col_5 STRING,col_6 STRING,col_7 STRING,
  col_8 STRING,col_9 STRING,col_10 STRING,col_11 STRING,col_12 STRING,col_13 STRING,col_14 STRING,
  col_15 STRING,col_16 STRING,col_17 STRING,col_18 STRING,col_19 STRING,col_20 STRING,col_21 STRING,
  col_22 STRING,col_23 STRING,col_24 STRING,col_25 STRING,col_26 STRING,col_27 STRING,col_28 STRING,
  col_29 STRING,col_30 STRING,col_31 STRING,col_32 STRING,col_33 STRING,col_34 STRING,col_35 STRING,
  col_36 STRING,col_37 STRING,col_38 STRING,col_39 STRING,col_40 STRING,col_41 STRING,col_42 STRING,
  col_43 STRING,col_44 STRING,col_45 STRING,col_46 STRING,col_47 STRING,col_48 STRING,col_49 STRING,
  col_50 STRING,col_51 STRING,col_52 STRING,col_53 STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED by 't'
STORED AS TEXTFILE
TBLPROPERTIES ("skip.header.line.count"="1");


CREATE VIEW omniture
AS
SELECT col_2 ts, col_8 ip, col_13 url, col_14 swid, col_50 city, col_51 country, col_53 state
FROM omniturelogs;

LOAD DATA LOCAL INPATH '/root/conf-hive/sample/products.tsv' OVERWRITE INTO TABLE products;
LOAD DATA LOCAL INPATH '/root/conf-hive/sample/users.tsv' OVERWRITE INTO TABLE users;
LOAD DATA LOCAL INPATH '/root/conf-hive/sample/omniture-logs.tsv' OVERWRITE INTO TABLE omniturelogs;