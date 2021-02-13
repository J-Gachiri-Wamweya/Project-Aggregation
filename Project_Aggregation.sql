-- PROJECT AGGREGATION

-- The projects table contains three columns: task_id, start_date, and end_date. 
-- The difference between end_date and start_date is 1 day for each row in the table. 
-- If task end dates are consecutive they are part of the same project. Projects do not overlap.
-- Write a query to return the start and end dates of each project, and the number of days it took to complete. 
-- Order by ascending project duration, and descending start date in the case of a tie

create database if not exists practicedb;
use practicedb;

create table if not exists projects (
task_id integer not null, 
start_date date, 
end_date date);
/*
insert into projects (task_id, start_date, end_date) 
VALUES 
(1, CAST('20-10-01' AS date), CAST('20-10-02' AS date)), 
(2, CAST('20-10-02' AS date), CAST('20-10-03' AS date)), 
(3, CAST('20-10-03' AS date), CAST('20-10-04' AS date)), 
(4, CAST('20-10-13' AS date), CAST('20-10-14' AS date)), 
(5, CAST('20-10-14' AS date), CAST('20-10-15' AS date)), 
(6, CAST('20-10-28' AS date), CAST('20-10-29' AS date)), 
(7, CAST('20-10-30' AS date), CAST('20-10-31' AS date));
*/
select * from projects;
with t1 as(
select * , coalesce(datediff(start_date, lag(start_date,1) over()),0) as start_diff, coalesce(datediff(lead(end_date,1) over(),end_date),0) as end_diff 
from projects
),
-- select * from t1;
t2 as (
select start_date, row_number() over (order by task_id) as s_id 
from t1 
where start_diff <>1
),
t3 as (
select end_date,row_number() over (order by task_id) as e_id 
from t1 
where end_diff <>1
)
select t2.start_date, t3. end_date, datediff(t3. end_date,t2.start_date) as project_duration 
from t2 
join t3 
on t2.s_id = t3.e_id
Order by project_duration, start_date;
