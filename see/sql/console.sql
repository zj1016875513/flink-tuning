
use exercrise_50;

create table student(s_id string,s_name string,s_birth string,s_sex string) row format delimited fields terminated by '\t';

create table course(c_id string,c_name string,t_id string) row format delimited fields terminated by '\t';

create table teacher(t_id string,t_name string) row format delimited fields terminated by '\t';

create table score(s_id string,c_id string,s_score int) row format delimited fields terminated by '\t';

load data local inpath '/opt/module/datas/student.csv' into table student;
load data local inpath '/opt/module/datas/course.csv' into table course;
load data local inpath '/opt/module/datas/teacher.csv' into table teacher;
load data local inpath '/opt/module/datas/score.csv' into table score;

create table person_info(
name string,
constellation string,
blood_type string)
row format delimited fields terminated by "\t";
load data local inpath "/opt/module/datas/constellation.txt" into table person_info;

-- insert into table person_info1
select tmp.info ,concat_ws('|',collect_set(name)) from
(select name,concat_ws('|',constellation,blood_type)info from person_info) tmp
group by info;

create table person_info1(
type string,
name string)
row format delimited fields terminated by "\t";




create table movie_info(
    movie string,
    category string)
row format delimited fields terminated by "\t";
load data local inpath "/opt/module/datas/movie_info.txt" into table movie_info;

select movie,category_name from movie_info1
    lateral view explode(split(category,',')) tmp as category_name;

select split('悬疑,动作,科幻,剧情',',');
select '悬疑,动作,科幻,剧情';

select movie,concat_ws(',',collect_set(category)) from movie_info1 group by movie;

select * from (
    (select *from score)a
    full join
    (select * from student )b
        on a.s_id=b.s_id);  //full join on


create table business(
name string,
orderdate string,
cost int
) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';
load data local inpath "/opt/module/datas/business.txt" into table business;

select * from business where substring(orderdate,1,7)='2017-04';
select count(distinct (name))  as allnum from business where substring(orderdate,1,7)='2017-04'; --求2017年4月份的总人数
select distinct(name), count(*) over() as allnum from business where substring(orderdate,1,7)='2017-04'; --2017年4月按名字去重，按最大窗口开窗，求总条数
select name,count(*) over() as allnum from business where substring(orderdate,1,7)='2017-04' group by name; --

select name ,orderdate,cost ,
       sum(cost) over (partition by name ,month(orderdate)) as month_cost
from business;

select name ,orderdate,cost,sum(cost) over (order by orderdate) from business;

//这两行的区别在于窗口大小不同，第一行的窗口是按天逐级递增的，第二行的窗口是按月份来
select name,orderdate,cost,sum(cost) over(partition by name order by orderdate)from business;
select name,orderdate,cost,sum(cost) over(partition by name order by month(orderdate))from business;


-- 查询商场每个月之内，每笔订单之后的总销售额
select name ,orderdate,cost,sum(cost) over(partition by month(orderdate) order by orderdate)
from business order by orderdate;

-- 查询每个人的所有消费情况，按订单日期排序，计算每次消费后自第一次消费的总金额
select name,orderdate,cost,sum(cost)over(partition by name order by orderdate) from business order by name;



select name ,orderdate,cost,
    sum(cost) over(partition by name ,month(orderdate) order by orderdate) `本月消费至今总额`,
    sum(cost) over(partition by name,month(orderdate))                     `本月消费总额`
from business order by name,orderdate; //要是后面没order by 那么名字和日期都是乱序


-- （3）将每个顾客的cost按照日期进行累加
select name,orderdate,cost `本次消费`,
       sum(cost) over() as `总销售额`,--所有行相加 窗口大小为全窗口
       sum(cost) over(partition by name) as `个人总消费`,--按name分组，组内数据相加 窗口大小为每个人的名字
       sum(cost) over(partition by name order by orderdate) as `个人累计消费(样式1)`,--按name分组，组内数据累加  窗口大小为名字，并按订单日期窗口大小逐渐递增
       sum(cost) over(partition by name order by orderdate rows between UNBOUNDED PRECEDING and current row ) as `个人累计消费(样式2)` ,--和sample3一样,由起点到当前行的聚合
       sum(cost) over(partition by name order by orderdate rows between 1 PRECEDING and current row) as `本次+上次消费累计`, --当前行和前面一行做聚合
       sum(cost) over(partition by name order by orderdate rows between 1 PRECEDING AND 1 FOLLOWING ) as `当日+前日+次日消费累计`,--当前行和前边一行及后面一行
       sum(cost) over(partition by name order by orderdate rows between current row and UNBOUNDED FOLLOWING ) as `当日至今消费累计` --当前行及后面所有行
from business;


-- 结果为2，可以看成是求uv
select name,count(*) over ()
from business
where substring(orderdate,1,7) = '2017-04'
group by name;



-- 结果为5，可以看成是求pv
select distinct (name),count(*) over ()
from business
where substring(orderdate,1,7) = '2017-04'

select name,orderdate,cost,
       lag(orderdate,1,'0000-00-00') over (partition by name order by orderdate) prev_time,
       lead(orderdate,1,'9999-99-99') over (partition by name order by orderdate) next_time
from business;


select name,
       orderdate,
       cost,
       FIRST_VALUE(orderdate) over (partition by name,month(orderdate) order by orderdate rows between unbounded preceding and unbounded following),
       LAST_VALUE(orderdate) over (partition by name,month(orderdate) order by orderdate rows between unbounded preceding and unbounded following)
from business;

select name,cost,orderdate as second,t1.first,datediff(orderdate,t1.first) as diff
from (
select name,orderdate,cost,
       year(orderdate)as year,
       first_value(orderdate) over(partition by name) as first,
       rank() over (partition by name order by orderdate) as rk
from business)t1
where rk=2 and t1.year='2017';

select if(datediff('2021-01-02','2021-01-03')>0,1,0)as result;

// 如果没有这句话，那么窗口大小只会到当前行，不会扩大到最后行  rows between unbounded preceding and unbounded following
select name,
       orderdate,
       cost,
       FIRST_VALUE(orderdate) over (partition by name,month(orderdate) order by orderdate ),
       LAST_VALUE(orderdate) over (partition by name,month(orderdate) order by orderdate )
from business;

//取所有订单中成交日期前20%的订单
select * from
(select name,orderdate,cost,ntile(5) over (order by orderdate) as sorted from business)
where sorted=1;



create table score_book(
name string,
subject string,
score int)
row format delimited fields terminated by "\t";
load data local inpath '/opt/module/datas/score_book.txt' into table score_book;

select name,subject,score,
       rank() over (partition by subject order by score desc ) rk,  //1,1,2,3
       dense_rank() over (partition by subject order by score desc )dense_rk,//1,1,3,4
       row_number() over (partition by subject order by score desc )row_num//1,2,3,4
from score_book






create external table gulivideo_ori(
    videoId string,
    uploader string,
    age int,
    category array<string>,
    length int,
    views int,
    rate float,
    ratings int,
    comments int,
    relatedId array<string>)
row format delimited fields terminated by "\t"
collection items terminated by "&"
stored as textfile
location '/gulivideo/video';


create external table gulivideo_user_ori(
    uploader string,
    videos int,
    friends int)
row format delimited
fields terminated by "\t"
stored as textfile
location '/gulivideo/user';


create table gulivideo_orc(
    videoId string,
    uploader string,
    age int,
    category array<string>,
    length int,
    views int,
    rate float,
    ratings int,
    comments int,
    relatedId array<string>)
stored as orc
tblproperties("orc.compress"="SNAPPY");


create table gulivideo_user_orc(
    uploader string,
    videos int,
    friends int)
row format delimited
fields terminated by "\t"
stored as orc
tblproperties("orc.compress"="SNAPPY");



Select brand as `品牌`,
if(datediff(first_end,last_start)>0, last_end- first_start, last_end- first_start +datediff(first_end,last_start))as `总营销天数`
From
(select brand,
first_value(startdate) over(partition by brand order by startdate,enddate) as first_start,
first_value(enddate) over(partition by brand order by startdate,enddate) as first_end,
last_value(startdate) over(partition by brand order by startdate,enddate) as last_start,
last_value(enddate) over(partition by brand order by startdate,enddate) as last_end
from marketing
)




select max(null);
select null;

create table food(
name string,
type string,
value int)
row format delimited fields terminated by "\t";
load data local inpath "/opt/module/datas/food.txt" into table food;


-- rk相当于第几次了
select
lower(name) as NAME,
max(if(type='breakfast',value,null)) Breakfast,
max(if(type='lunch',value,null)) Lunch,
max(if(type='supper',value,null)) Supper
from
(select name,type,value,row_number() over(partition by type order by name) rk from food) t1
group by t1.rk,name
order by name;

-- 这种有问题，如果lee吃了两次晚餐，第一次30 第二次300  那么第一次30就不见了
select
lower(name) as NAME,
max(if(type='breakfast',value,null) ) as Breakfast ,
max(if(type='lunch',value,null)) as Lunch ,
max(if(type='supper',value,null)) as Supper
from food
group by food.name
order by name;



select date_format('20100509','yyyyMMdd');
select month(date_format('20100509','yyyyMMdd'));

select month(from_unixtime(unix_timestamp('20120101','yyyyMMdd'),'yyyy-MM-dd'));

select substring('20120101',1,6);




