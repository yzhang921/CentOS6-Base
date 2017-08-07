create database oreilly;
use oreilly;
create table sample_data (
  id bigint,
  val int,
  zerofill string,
  name string,
  assertion boolean,
  city string,
  state string
)
row format delimited fields terminated by ",";

refresh sample_data;

-- Q1 count
select count(*) from sample_data;
-- Q2 max
select max(name) from sample_data;

select min(name) as first_in_alpha_order, assertion
from sample_data group by assertion;


select avg(val), min(name), max(name) from sample_data
where name between 'A' and 'D';


select count(name) as num_names, assertion
from sample_data group by assertion;

show table stats sample_data;


select avg(length(city)) + avg(length(state))
from sample_data;


create table usa_cities(
  id int,
  city string,
  state string
)
row format delimited fields terminated by ",";

!hdfs dfs -put usa_cities.csv /user/hive/warehouse/oreilly.db/usa_cities/;

select count(*) from usa_cities;
create view normalized_view
    as
select one.id, one.val, one.zerofill, one.name,
       one.assertion, two.id as location_id
  from sample_data one join usa_cities two on (one.city = two.city and one.state = two.state);


select one.id, one.location_id,
       two.id, two.city, two.state
from normalized_view one join usa_cities two on (one.location_id = two.id)
WHERE one.id IN (2293548, 2293549, 2293550, 2293551, 2293552)
;

select id, city, state from sample_data
 where id in (2293548, 2293549, 2293550, 2293551, 2293552);

--------------------------
--  Tunning
--------------------------

-- normalized_text
create table normalized_text
row format delimited fields terminated by ","
as select * from normalized_view;

show table stats normalized_text;

-- Converting to Parquet Format
create table normalized_parquet
stored as parquet
as select * from normalized_text;


select max(name) from sample_data;
select max(name) from normalized_text;
select max(name) from normalized_parquet;


select avg(val), min(name), max(name) from sample_data where name between 'A' and 'D';
select avg(val), min(name), max(name) from normalized_text where name between 'A' and 'D';
select avg(val), min(name), max(name) from normalized_parquet where name between 'A' and 'D';



-- Deep Dive: Joins and the Role of Statistics
create table stats_demo like sample_data;
show table stats stats_demo;
show column stats stats_demo;

-- Loading Data and Computing Stats
insert into stats_demo select * from sample_data limit 1e6;
compute stats stats_demo;
show table stats stats_demo;
show column stats stats_demo;

-- Reviewing the EXPLAIN Plan
-- before compute stats of sample_data
explain select count(*) from sample_data join stats_demo
using (id) where substr(sample_data.name,1,1) = 'G';


-- compute stats of sample_data
compute stats sample_data;
show table stats sample_data;
show column stats sample_data;
explain select count(*) from sample_data join stats_demo
using (id) where substr(sample_data.name,1,1) = 'G';