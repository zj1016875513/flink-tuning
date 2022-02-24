
--求本周一
SELECT  date_sub(next_day('2021-04-06','mo'),7);
--求本周日
SELECT  date_sub(next_day('2021-04-11','mo'),1);

select now();
select current_date();
select current_timestamp();

-- 求当前时间 2021-06-03 20:19:43
select date_format(current_timestamp(),'yyy-MM-dd HH:mm:ss');
select date_format(now(),'yyy-MM-dd HH:mm:ss');

-- add_months(start_date, num_months)	Returns the date that is `num_months` after `start_date`.
SELECT add_months('2016-08-31', 1);
//2016-09-30

-- current_date()	Returns the current date at the start of query evaluation. All calls of current_date within the same query return the same value.
SELECT current_date();
-- 2021-06-03

-- current_date	Returns the current date at the start of query evaluation.
SELECT current_date;
-- 2021-06-03

-- current_timestamp()	Returns the current timestamp at the start of query evaluation. All calls of current_timestamp within the same query return the same value.
SELECT current_timestamp();
-- 2021-06-03 19:02:17.917000000

-- current_timestamp	Returns the current timestamp at the start of query evaluation.
SELECT current_timestamp;
-- 2021-06-03 19:02:17.917000000

-- date_add(start_date, num_days)	Returns the date that is `num_days` after `start_date`.
SELECT date_add('2016-07-30', 1);
-- 2016-07-31 返回明天的数据

-- date_format(timestamp, fmt)	Converts `timestamp` to a value of string in the format specified by the date format `fmt`.
SELECT date_format('2016-04-08', 'yyyy-MM');
-- 2016-04

-- weekofyear(date)	Returns the week of the year of the given date.
-- A week is considered to start on a Monday and week 1 is the first week with >3 days.
SELECT weekofyear('2019-05-08'); //返回这个日期在当年的周数

-- date_part(field, source)	Extracts a part of the date/timestamp or interval source.
SELECT date_part('week', timestamp'2019-05-08 01:00:00.123456');  //返回当年的周数

SELECT date_part('YEAR', TIMESTAMP '2019-08-12 03:02:01.123456');
SELECT date_part('second', TIMESTAMP '2019-08-12 03:02:01.123456');

SELECT date_part('minute', TIMESTAMP '2019-08-12 03:02:01.123456');

SELECT date_part('doy', DATE'2019-08-12');  //doy是返回当年的天数

SELECT date_part('days', interval 1 year 10 months 5 days);//返回的是天数
SELECT date_part('seconds', interval 5 hours 30 seconds 1 milliseconds 1 microseconds); //返回的是秒数
-- date_sub(start_date, num_days)	Returns the date that is `num_days` before `start_date`.
SELECT date_sub('2016-07-30', 1); //返回当前日期1天前的日期
//2016-07-29

-- date_trunc(fmt, ts)	Returns timestamp `ts` truncated to the unit specified by the format model `fmt`.
SELECT date_trunc('YEAR', '2015-03-05T09:32:05.359'); //返回本年的最早时间
//2015-01-01 00:00:00.000000000
SELECT date_trunc('MM', '2015-03-05T09:32:05.359');  //返回本月的最早的时间
//2015-03-01 00:00:00.000000000
SELECT date_trunc('DD', '2015-03-05T09:32:05.359');  //返回当天的最早时间
-- 2015-03-05 00:00:00.000000000
SELECT date_trunc('HOUR', '2015-03-05T09:32:05.359');//返回本小时的最早时间
-- 2015-03-05 09:00:00.000000000
SELECT date_trunc('MILLISECOND', '2015-03-05T09:32:05.123456'); //返回本毫秒的最早时间

-- datediff(endDate, startDate)	Returns the number of days from `startDate` to `endDate`.
SELECT datediff('2009-07-31', '2009-07-30'); //返回第一个日期减去第二个日期的差值天数
// 1

-- dayofweek(date)	Returns the day of the week for date/timestamp (1 = Sunday, 2 = Monday, ..., 7 = Saturday).
SELECT dayofweek('2021-06-03'); //返回今天是星期几
-- 5  //当天为星期四

-- weekday(date)	Returns the day of the week for date/timestamp (0 = Monday, 1 = Tuesday, ..., 6 = Sunday).
SELECT weekday('2021-06-03');
-- 3  //当天为星期四

-- dayofyear(date)	Returns the day of year of the date/timestamp.
SELECT dayofyear('2016-04-09'); //返回这个日期是这个年度的第多少天
-- 100

-- year(date)	Returns the year component of the date/timestamp.
SELECT year('2016-07-30'); //返回当前日期的年份
-- 2016

-- month(date)	Returns the month component of the date/timestamp.
SELECT month('2016-07-30');  //返回当前日期的月份数
-- 7

-- hour(timestamp)	Returns the hour component of the string/timestamp.
SELECT hour('2009-07-30 12:58:59'); //获取当前时间戳的小时
-- 12

-- minute(timestamp)	Returns the minute component of the string/timestamp.
SELECT minute('2009-07-30 12:58:59'); //返回参数时间的分钟数
-- 58

-- second(timestamp)	Returns the second component of the string/timestamp.
SELECT second('2009-07-30 12:58:59'); //返回参数时间的描述
--59

-- last_day(date)	Returns the last day of the month which the date belongs to.
SELECT last_day('2009-01-12');  //返回参数日期的月份的最后一天


-- make_date(year, month, day)	Create date from year, month and day fields.
SELECT make_date(2013, 7, 15);//通过3个参数，创造出一个日期
-- 2013-07-15
SELECT make_date(2019, 7, NULL); //有null则日期为null
-- null
SELECT make_date(2019, 2, 30); //不存在的日期也为null
-- null

-- make_timestamp(year, month, day, hour, min, sec[, timezone])	Create timestamp from year, month, day, hour, min, sec and timezone fields.
SELECT make_timestamp(2014, 12, 28, 6, 30, 45.887);
-- 2014-12-28 06:30:45.887000000
SELECT make_timestamp(2014, 12, 28, 6, 30, 45.887, 'UTC'); //将所有参数拼接成UTC0区的日期时间，再将时间的小时数值加上当地时区
-- 2014-12-28 14:30:45.887000000

-- months_between(timestamp1, timestamp2[, roundOff])
-- If `timestamp1` is later than `timestamp2`, then the result is positive.
-- If `timestamp1` and `timestamp2` are on the same day of month,
-- or both are the last day of month, time of day will be ignored. Otherwise,
-- the difference is calculated based on 31 days per month, and rounded to 8 digits unless roundOff=false.
SELECT months_between('1997-02-28 10:30:00', '1996-10-30'); //返回第一个参数与第二个参数之间的月份的间隔数，
SELECT months_between('1997-02-28 10:30:00', '1996-10-30',false);

-- next_day(start_date, day_of_week)	Returns the first date which is later than `start_date` and named as indicated.
SELECT next_day('2015-01-14', 'TU'); //输出下一个星期二的日期为多少
-- 2015-01-20

-- now()	Returns the current timestamp at the start of query evaluation.
SELECT now(); //返回当前时间的时间戳
-- 2021-06-03 19:54:21.205000000

-- quarter(date)	Returns the quarter of the year for date, in the range 1 to 4.
SELECT quarter('2016-08-31');  //返回本月份的季度 春夏秋冬分别为1234
-- 3

-- to_date(date_str[, fmt])	Parses the `date_str` expression with the `fmt` expression to a date.
-- Returns null with invalid input. By default, it follows casting rules to a date if the `fmt` is omitted.
SELECT to_date('2009-07-30 04:17:52'); //如果没有格式字符串，则自动转换为规定格式，即年月日
SELECT to_date('2016-12-31', 'yyyy-MM-dd');

-- unix_timestamp([timeExp[, fmt]])	Returns the UNIX timestamp of current or specified time.
SELECT unix_timestamp(); //输出精确到秒的当前时间戳
-- 1622804366

-- to_timestamp(timestamp_str[, fmt])	Parses the `timestamp_str` expression with the `fmt` expression to a timestamp.
-- Returns null with invalid input. By default, it follows casting rules to a timestamp if the `fmt` is omitted.
SELECT to_timestamp('2016-12-31 00:12:00');
-- 2016-12-31 00:12:00.000000000
SELECT to_timestamp('2016-12-31', 'yyyy-MM-dd');
-- 2016-12-31 00:00:00.000000000

-- to_unix_timestamp(timeExp[, fmt])	Returns the UNIX timestamp of the given time.
SELECT to_unix_timestamp('2016-04-08', 'yyyy-MM-dd'); //输出精确到秒的时间戳
-- 1460044800

-- to_utc_timestamp(timestamp, timezone)	Given a timestamp like '2017-07-14 02:40:00.0', interprets it as a time in the given time zone, and renders that time as a timestamp in UTC. For example, 'GMT+1' would yield '2017-07-14 01:40:00.0'.
SELECT to_utc_timestamp('2016-08-31', 'Asia/Seoul'); //第一个参数为UTC时间，第二个参数为指定的时区，输出由UTC时间转换为指定的时区之后的日期时间
-- 2016-08-30 15:00:00.000000000

-- from_unixtime(unix_time[, fmt])	Returns `unix_time` in the specified `fmt`.
SELECT from_unixtime(0, 'yyyy-MM-dd HH:mm:ss');//将时间戳0 解析为它自己的时间 并格式化
-- 1970-01-01 08:00:00

SELECT from_unixtime(0); //解析时间戳
-- 1970-01-01 08:00:00

-- from_utc_timestamp(timestamp, timezone)	Given a timestamp like '2017-07-14 02:40:00.0', interprets it as a time in UTC, and renders that time as a timestamp in the given time zone. For example, 'GMT+1' would yield '2017-07-14 03:40:00.0'.
SELECT from_utc_timestamp('2016-08-31 08:07:06', 'Asia/Seoul'); //将0区的时间 解析为首尔的时间(东9区) 注意是时间戳类型
-- 2016-08-31 17:07:06.000000000

-- trunc(date, fmt)	Returns `date` with the time portion of the day truncated to the unit specified by the format model `fmt`.
SELECT trunc('2019-08-04', 'week');
-- 2019-07-29
SELECT trunc('2019-08-04', 'quarter');
-- 2019-07-01 季节？
SELECT trunc('2009-02-12', 'MM');
-- 2009-02-01
SELECT trunc('2015-10-27', 'YEAR');
-- 2015-01-01

-- unix_date(date)	Returns the number of days since 1970-01-01.
-- SELECT unix_date(DATE("1970-01-02"));

-- unix_micros(timestamp)	Returns the number of microseconds since 1970-01-01 00:00:00 UTC.
-- SELECT unix_micros(TIMESTAMP('1970-01-01 00:00:01Z'));

-- unix_millis(timestamp)	Returns the number of milliseconds since 1970-01-01 00:00:00 UTC. Truncates higher levels of precision.
-- SELECT unix_millis(TIMESTAMP('1970-01-01 00:00:01Z'));

-- unix_seconds(timestamp)	Returns the number of seconds since 1970-01-01 00:00:00 UTC. Truncates higher levels of precision.
-- SELECT unix_seconds(TIMESTAMP('1970-01-01 00:00:01Z'));

-- current_timezone()	Returns the current session local timezone.
-- SELECT current_timezone();
-- Etc/UTC

-- timestamp_micros(microseconds)	Creates timestamp from the number of microseconds since UTC epoch.
-- SELECT timestamp_micros(1230219000123123);

-- timestamp_millis(milliseconds)	Creates timestamp from the number of milliseconds since UTC epoch.
-- SELECT timestamp_millis(1230219000123);

-- timestamp_seconds(seconds)	Creates timestamp from the number of seconds (can be fractional) since UTC epoch.
-- SELECT timestamp_seconds(1230219000);

-- date_from_unix_date(days)	Create date from the number of days since 1970-01-01.
-- SELECT date_from_unix_date(1);
-- 1970-01-02

SELECT sequence(to_date('2018-01-01'), to_date('2018-12-01'), interval 1 month); //一年所有月份的第一天
-- [2018-01-01,2018-02-01,2018-03-01,2018-04-01,2018-05-01,2018-06-01,2018-07-01,2018-08-01,2018-09-01,2018-10-01,2018-11-01,2018-12-01]
select sequence(1,10);
//[1,2,3,4,5,6,7,8,9,10]
select sequence(1,12,2);
-- [1,3,5,7,9,11]

select explode(sequence(1,10));
select  explode(array(1,2,3,4,5));

SELECT get_json_object('{"a":"b"}', '$.a');

use exercrise_50



SELECT arrays_zip(array(1, 2), array(2, 3), array(3, 4));
SELECT arrays_zip(array(1, 2, 3), array(4, 5, 6));






desc function extended round;
select round(1.2345,2);
select round(1.56789,2);



-- 如何将日期02/22/2015格式转为2015-02-22格式？
select substring(reverse('3/12/1981'),1,4);  --这就错了，从1981年转到了1891年
--正确做法
select unix_timestamp('02/22/2015' ,'MM/dd/yyyy'); --先转为时间戳
select from_unixtime(unix_timestamp('02/22/2015' ,'MM/dd/yyyy'), 'yyyy-MM-dd');
select from_unixtime(unix_timestamp('22/02/2015' ,'dd/MM/yyyy'), 'yyyy-MM-dd');


select date_format(date_format(now(),'MM-dd-yyyy'),'yyyy-MM-dd');
select date_format('03/12/1981','MM/dd/yyyy');
select date_format('3-12-1981','yyyy-MM-dd');
select date_format('3-12-1981','MM/dd/yyyy');

SELECT regexp_extract('100-200', '(\\d+)-(\\d+)', 2);
SELECT regexp_replace('100-200', '(\\d+)', 'num');
select regexp_extract('3/12/1981','(\\d+)/(\\d+)/(\\d+)',3);
select r

select split('3/12/1981','/')[2];--只能打散为数组


desc function extended date_format;
desc function extended regexp_extract;
desc function extended regexp_replace;



select to_date('3/12/1981','MM/dd/yyyy')
select to_date('3-12-1981','MM/dd/yyyy')
select year('3/12/1981')
select year('3-12-1981')
select year('3-12-1981')
select year('1981-3-12')

select conv()
select date_format(now(),'MM/dd/yyyy');
select date_format('06/22/2021','MM');

desc function extended conv;
desc function extended to_date;
desc function extended length;

select length('abcde');

use gmall;


SELECT  named_struct('name',1,'age',2,'gender',3).age;

-- insert overwrite table ads_page_path
-- select * from ads_page_path
-- union
SELECT
	'2021-04-01',
	  source,target,count(*)

from
(SELECT
	concat('step-',rn,source) source,
	concat('step-',rn+1,target) target
from
(SELECT
    mid_id ,last_page_id ,page_id ,
    page_id  source ,
    lead(page_id,1,null) over(PARTITION by session_id order by ts) target,
    ts,session_id,
    ROW_NUMBER () over(PARTITION by session_id order by ts) rn
from
(SELECT
	mid_id ,last_page_id ,page_id ,ts,
	concat(mid_id ,'_',last_value(session_start_ts,true) over(PARTITION by mid_id order by ts)) session_id
from
(SELECT
	mid_id ,last_page_id ,page_id ,ts,
	if(last_page_id is null,ts,null ) session_start_ts
from dwd_page_log
where dt='2021-04-01') t1 ) t2 ) t3 ) t4
GROUP by source,target;

--求用户页面浏览路径的排序的需求，比如可以从主页跳转出去，可以从主页跳转到商品详情页，可以从主页到我的详情，可以从主页到搜索页面，可以从主页到商品列表
--先找出主页，特征为last_page_id为null，则将ts作为会话启动时间session_start_ts 然后再将设备id和这个会话最后启动时间进行concat形成session_id，
--然后用page_id作为sourse再用lead求出下一页作为target，然后用rownumber对会话id进行分许，对时间戳进行排序
--分组之后将step-作为前缀，concat('step-'+rn+source)作为source,concat('step-'+rn+1+target)作为target
--最后再将今日日期作为dt，然后加上source，target，count(*)，然后groupby source，target求出最终值

-- 求pv
select '2021-04-01',sum(aaa.page_count)as num from(
select explode(page_stats)as aaa from dws_visitor_action_daycount where dt='2021-04-01')

SELECT
	'2021-04-01',
	count(*)
from
(SELECT
	user_id
from dwd_page_log
where dt='2021-04-01' and user_id is not null
GROUP by user_id ) tmp


select count(*)
from (
select user_id
from dwd_page_log
where dt='2021-04-01'and user_id is not null
group by user_id)


select count(distinct user_id) from dwd_page_log where dt='2021-04-01'and user_id is not null


select count(*) from dwt_visitor_topic where dt ='2021-04-01' and visit_date_first='2021-04-01';



-- 各渠道跳出率计算方法
select
	'2021-04-01',
	channel,
	count(*) pv_count,
	sum(if(visit_page_counts = 1,1,0)) bounce_count,
	-- 是double 注意类型，需要强制为 DECIMAL(16,2)
	cast(sum(if(visit_page_counts = 1,1,0)) / count(*) * 100 as DECIMAL(16,2)) bounce_rate
from
(select
	--各个渠道的各个session，访问页面的总次数，访问一次页面的称为跳出访问的session
	 channel ,session_id, count(*) visit_page_counts
from
(select
	mid_id  ,channel ,session_start_ts,
	--指定了order by ，没写windows字句 ，默认窗口是 上无边界到当前行  注意:只到当前行，如果有两次会话，那也有两次sessionid
	-- 将设备id和最后的会话启动时间通过中间的_拼接起来作为 会话id
	concat(mid_id ,'_',last_value(session_start_ts,true) over(PARTITION by mid_id order by ts)) session_id
from
(SELECT
	mid_id ,last_page_id ,page_id ,ts ,channel ,
	if(last_page_id is null,ts,null ) session_start_ts --求出会话启动时间 session_start_ts
from dwd_page_log
where dt='2021-04-01'  ) t1
) t2
GROUP by channel ,session_id) t3
GROUP by channel;



select
	'2021-04-01',
	new_or_old,
	count(*) pv_count,
	sum(if(visit_page_counts = 1,1,0)) bounce_count,
	-- 是double 注意类型，需要强制为 DECIMAL(16,2)
	cast(sum(if(visit_page_counts = 1,1,0)) / count(*) * 100 as DECIMAL(16,2)) bounce_rate
from
(select
     new_or_old ,session_id, count(*) visit_page_counts
from
(select
	mid_id  ,new_or_old ,
	--指定了order by ，没写windows字句 ，默认窗口是 上无边界到当前行
	concat(mid_id ,'_',last_value(session_start_ts,true) over(PARTITION by mid_id order by ts)) session_id
from
(SELECT
	t2.mid_id,session_start_ts,ts,
	if(visit_date_first='2021-04-01','new','old')   new_or_old
from
(SELECT
	mid_id ,last_page_id ,page_id ,ts ,
	if(last_page_id is null,ts,null ) session_start_ts
from dwd_page_log
where dt='2021-04-01'  ) t2
left join
(select
	mid_id ,visit_date_first
from dwt_visitor_topic
where dt='2021-04-01' ) t1
on t2.mid_id=t1.mid_id ) t3
) t4
GROUP by  new_or_old,session_id ) t5
GROUP  by new_or_old


select channel, count(1)as num from dwd_page_log where dt='2021-04-01' group by channel  --各渠道所有页面数，好像没有意义
select channel, count(1)as num from dwd_start_log where dt='2021-04-01' group by channel --启动页面数，各渠道访问次数


select '2021-04-01', sum(if(payment_count>0,1,0)) ,sum(if(payment_count=0,1,0)) from dws_user_action_daycount where dt='2021-04-01'


select '2021-04-01',spu_id,spu_name,sum(order_count) num
from
(select sku_id,order_count from dws_sku_action_daycount where dt='2021-04-01' and order_count>0) t1
left join
(select id ,spu_name,spu_id from dim_sku_info where dt='2021-04-01') t2
on t1.sku_id=t2.id
group by spu_id,spu_name
order by num desc
limit 10;

select '2021-04-01',tm_id,tm_name,sum(order_count) order_num from
(select sku_id,order_count from dws_sku_action_daycount where dt='2021-04-01' and order_count>0)t1
left join
(select id,tm_id,tm_name from dim_sku_info where dt='2021-04-01') t2
on t1.sku_id=t2.id
group by tm_id,tm_name
order by order_num desc
limit 10;

select '2021-04-01',sku_id,sku_name,order_coupon_count
from
(select sku_id,order_coupon_count from dws_sku_action_daycount where dt='2021-04-01' and order_coupon_count>0) t1
left join
(select id ,sku_name from dim_sku_info where dt='2021-04-01') t2
on t1.sku_id=t2.id
order by order_coupon_count desc
limit 10;

select '2021-04-01',count(1) from dwt_user_topic where dt='2021-04-01' and login_date_last<=date_sub('2021-04-01',7);



SELECT
	'2021-04-01',
	concat(date_sub(next_day('2021-04-01','mo'),21),'_','2021-04-01'),
	count(*)
from
(SELECT
	mid_id ,count(*)
from
(--求本周至少打开一次app的人
SELECT
	mid_id
	--一个设备是一行
from dwt_visitor_topic
--本周打开app，最后一次访问时间 >=本周一
where dt='2021-04-01' and
visit_date_last  >= date_sub(next_day('2021-04-01','mo'),7)
UNION all
--求上周至少打开一次app的人
-- dwt_visitor_topic 不会保留历史状态
--  mid_1 上周访问了，这周一也访问了，visit_date_last=本周一
--  mid_1 上周没有访问，这周一访问了，visit_date_last=本周一
-- 历史状态只能从dws取
SELECT
	mid_id
from  dws_visitor_action_daycount
where dt BETWEEN date_sub(next_day('2021-04-01','mo'),14)
		and  date_sub(next_day('2021-04-01','mo'),8)
GROUP by mid_id
UNION all
--求上上周至少打开一次app的人
SELECT
	mid_id
from  dws_visitor_action_daycount
where dt BETWEEN date_sub(next_day('2021-04-01','mo'),21)
		and  date_sub(next_day('2021-04-01','mo'),15)
GROUP by mid_id  ) tmp
GROUP by mid_id
having count(*) = 3 ) tmp2



SELECT
	-- 我们已经将4-1的数据导入到hive中，有4-1日的数据 ， 有4-1的日活数据
	--有4-1日的日活，可以求 (4-1 - 1) 新增日期 ，留存1天的留存人数和留存率
    '2021-04-01',
    date_sub('2021-04-01',1) create_date,
   1 retention_day,
   nvl(sum(if(visit_date_last =  '2021-04-01',1,0)),0) retention_count,
   count(*)  new_visitor_count,
   cast(nvl(sum(if(visit_date_last =  '2021-04-01',1,0)) / count(*) * 100,0) as DECIMAL(16,2)) retention_rate
from  dwt_visitor_topic
-- 新增日期是date_sub('2021-04-01',1)= 3-31日
where visit_date_first =date_sub('2021-04-01',1)
--且4-1日使用了app的人数
--and visit_date_last =  '2021-04-01'
union all
SELECT
	-- 我们已经将4-1的数据导入到hive中，有4-1日的数据 ， 有4-1的日活数据
	--有4-1日的日活，可以求 (4-1 - 2) 新增日期 ，留存2天的留存人数和留存率
    '2021-04-01',
    date_sub('2021-04-01',2) create_date,
   2 retention_day,
   nvl(sum(if(visit_date_last =  '2021-04-01',1,0)),0) retention_count,
   count(*)  new_visitor_count,
   cast(nvl(sum(if(visit_date_last =  '2021-04-01',1,0)) / count(*) * 100,0) as DECIMAL(16,2)) retention_rate
from  dwt_visitor_topic
-- 新增日期是date_sub('2021-04-01',2)= 3-30日
where visit_date_first =date_sub('2021-04-01',2)
union all
SELECT
	-- 我们已经将4-1的数据导入到hive中，有4-1日的数据 ， 有4-1的日活数据
	--有4-1日的日活，可以求 (4-1 - 2) 新增日期 ，留存2天的留存人数和留存率
    '2021-04-01',
    date_sub('2021-04-01',3) create_date,
   3 retention_day,
   nvl(sum(if(visit_date_last =  '2021-04-01',1,0)),0) retention_count,
   count(*)  new_visitor_count,
   cast(nvl(sum(if(visit_date_last =  '2021-04-01',1,0)) / count(*) * 100,0) as DECIMAL(16,2)) retention_rate
from  dwt_visitor_topic
-- 新增日期是date_sub('2021-04-01',2)= 3-30日
where visit_date_first =date_sub('2021-04-01',3)



select
		'2021-04-01',
		new_or_old,
		sum(duration) duration,
		sum(page_count) page_count,
		sum(pv_count) pv_count,
	    date_format(to_utc_timestamp(from_unixtime(sum(duration) /  sum(page_count)), 'Asia/Shanghai') ,'HH:mm:ss') avg_duration,
		ceil(sum(page_count) / sum(pv_count)) avg_page_count
from
(SELECT
	mid_id ,
	cast(sum(during_time) / 1000 as string)  duration,
	count(*)  page_count
from dwd_page_log
where dt='2021-04-01'
GROUP by mid_id  ) t1
 join
(
	select
		mid_id ,if(visit_date_first='2021-04-01','new','old') new_or_old
	from dwt_visitor_topic
	where dt='2021-04-01'
)t3
on t1.mid_id=t3.mid_id
join
(
select
	mid_id ,
	count(*) pv_count
from  dwd_start_log
where dt='2021-04-01'
GROUP by mid_id )  t2
on t1.mid_id=t2.mid_id
GROUP  by new_or_old;











