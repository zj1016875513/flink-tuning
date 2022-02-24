
set hive.exec.mode.local.auto=true;
set hive.exec.mode.local.auto=false;
set hive.exec.mode.local.auto;

set hive.exec.mode.local.auto=true;
set hive.exec.mode.local.auto=true;

show tables ;

show databases ;
create database exercrise_50;
use exercrise_50;



create table student(s_id string,s_name string,s_birth string,s_sex string) row format delimited fields terminated by ' ';
create table course(c_id string,c_name string,t_id string) row format delimited fields terminated by ' ';
create table teacher(t_id string,t_name string) row format delimited fields terminated by ' ';
create table score(s_id string,c_id string,s_score int) row format delimited fields terminated by ' ';

load data local inpath '/opt/module/datas/student.csv' into table student;
load data local inpath '/opt/module/datas/course.csv' into table course;
load data local inpath '/opt/module/datas/teacher.csv' into table teacher;
load data local inpath '/opt/module/datas/score.csv' into table score;


select * from student;



//1、查询"01"课程比"02"课程成绩高的学生的信息及课程分数:
select student.*,a.s_score as 01_score,b.s_score as b_score
from student
            join score a on student.s_id=a.s_id and a.c_id='01'
            left join score b on  student.s_id=b.s_id and b.c_id ='02'
where a.s_score>b.s_score;

--a为01课程，b为02课程
select student.*,a.s_score as 01_score,b.s_score as 02_score
from student
         inner join score a on student.s_id=a.s_id and a.c_id='01'
         left join score b on student.s_id=b.s_id and b.c_id='02'
where  a.s_score>b.s_score;


select student.*,a.s_score as 01_score,b.s_score as 02_score
from student
         join score a on  a.c_id='01'
         join score b on  b.c_id='02'
where  a.s_id=student.s_id and b.s_id=student.s_id and a.s_score>b.s_score;

// 2、查询"01"课程比"02"课程成绩低的学生的信息及课程分数:

select student.*,a.s_score as 01_score,b.s_score as 02_score
from student
         join score a on student.s_id=a.s_id and a.c_id='01'
         left join score b on student.s_id=b.s_id and b.c_id='02'
where a.s_score<b.s_score;


select student.*,a.s_score as 01_score,b.s_score as 02_score
from student
         join score a on  a.c_id='01'
         join score b on  b.c_id='02'
where  a.s_id=student.s_id and b.s_id=student.s_id and a.s_score<b.s_score;
// 3、查询平均成绩大于等于60分的同学的学生编号和学生姓名和平均成绩:
select  student.s_id,student.s_name,tmp.`平均成绩`
from student join (
    select score.s_id,round(avg(score.s_score),1)as `平均成绩`
    from score group by s_id)as tmp
on student.s_id = tmp.s_id
where tmp.`平均成绩`>=60;

select * from (
select  student.s_id,student.s_name,round(avg (score.s_score),1) as `平均成绩` from student
    join score on student.s_id = score.s_id
group by student.s_id,student.s_name
having avg (score.s_score) >= 60) order by `平均成绩` desc ;
-- – 4、查询平均成绩小于60分的同学的学生编号和学生姓名和平均成绩:
-- – (包括有成绩的和无成绩的)

select  student.s_id,student.s_name,tmp.avgScore from student
    join (
    select score.s_id,round(avg(score.s_score),1)as avgScore from score group by s_id)as tmp
    on  student.s_id=tmp.s_id
where tmp.avgScore < 60
union all
select  s2.s_id,s2.s_name,0 as avgScore from student s2
where s2.s_id not in
      (select distinct sc2.s_id from score sc2);  //找出所有得分的同学的s_id


select  score.s_id,student.s_name,round(avg (score.s_score),1) as avgScore from student
inner join score on student.s_id=score.s_id
group by score.s_id,student.s_name
having avg (score.s_score) < 60
union all
select  s2.s_id,s2.s_name,0 as avgScore from student s2
where s2.s_id not in
      (select distinct sc2.s_id from score sc2);
-- – 5、查询所有同学的学生编号、学生姓名、选课总数、所有课程的总成绩:

-- select student.s_id,student.s_name,count(score.c_id) as count_class,sum(score.s_score) as count_score
-- from student join score on student.s_id=score.s_id
-- group by student.s_id,student.s_name;
//这个是我写的，错了，需要left join  因为有的学生没有选课，也没有总分。但是按要求是需要显示，所以需要左外连接

select student.s_id,student.s_name,(count(score.c_id) )as total_count,sum(score.s_score)as total_score
from student
         left join score on student.s_id=score.s_id
group by student.s_id,student.s_name ;

-- – 6、查询"李"姓老师的数量:
select t_name as teacher_name,count(t_name) as teacher_number from teacher where t_name like '李%' group by t_name;

select t_name,count(t_name) from teacher  where t_name like '李%' group by t_name;
-- – 7、查询学过"张三"老师授课的同学的信息:


select student.* from student
                          join score on student.s_id =score.s_id
                          join  course on course.c_id=score.c_id
                          join  teacher on course.t_id=teacher.t_id and t_name='张三';
-- – 8、查询没学过"张三"老师授课的同学的信息:
-- 先求出学过张三老师授课的同学的id，在用student表left join这个临时表，再找出临时表的is_id等于null的学生的信息
select student.*
from student left join
     (select s_id from score join course on score.c_id=course.c_id
                             join teacher on course.t_id = teacher.t_id and t_name ='张三') aaa
     on student.s_id=aaa.s_id
where aaa.s_id is null;

select student.* from student
                          left join (select s_id from score
                                                          join  course on course.c_id=score.c_id
                                                          join  teacher on course.t_id=teacher.t_id and t_name='张三')tmp
                                    on  student.s_id =tmp.s_id
where tmp.s_id is null;
-- – 9、查询学过编号为"01"并且也学过编号为"02"的课程的同学的信息:
//用一次join求出
select distinct (t.id),s_name,s_birth,s_sex from (
select stu.s_id as id,* ,count(*) over (partition by s_name) as num from
           student stu join score sco on stu.s_id=sco.s_id and sco.c_id in ('01','02')) t where num=2 order by id ;

//这种就错了，因为可能学生只选过一门01   或者只选过一门02  都可以被查出来， 所以需要两次查询，先查选了01的，再查选了02的

select stu.s_id,s_name,s_birth,s_sex,c_id,s_score,count(*) over (partition by s_name) as num from
           student stu join score sco on stu.s_id=sco.s_id and sco.c_id in ('01','02');


select * from student
    join
    (select s_id from score where score.c_id ='01')aaa  on student.s_id=aaa.s_id
    join
    (select s_id from score where score.c_id ='02')bbb  on student.s_id=bbb.s_id;

select * from student
                  join (select s_id from score where c_id =1 )tmp1
                       on student.s_id=tmp1.s_id
                  join (select s_id from score where c_id =2 )tmp2
                       on student.s_id=tmp2.s_id;
-- – 10、查询学过编号为"01"但是没有学过编号为"02"的课程的同学的信息:

//下列的错了，因为总不可能一个字段即等于01又等于02，sql的粒度是一行，而不是多行，这不是where后面多条件的用法。这里需要先求01的学生t1，再leftjoin表（求出02的学生）t2再选择t2.s_id为null的
select student.s_id,s_name,s_birth,s_sex,score.c_id from student join score on student.s_id=score.s_id where score.c_id=01 and score.c_id=02;

select * from student
    join (select s_id from score where c_id =01)tmp1 on student.s_id=tmp1.s_id
    left join (select s_id from score where c_id=02)tmp2 on student.s_id=tmp2.s_id where tmp2.s_id is null;

select * from student
                  join (select s_id from score where score.c_id='01')aaa
                       on student.s_id=aaa.s_id -- 此时已经过滤出了所有有学过01的s_id了
                  left join (select s_id from score where score.c_id='02' )bbb
                            on student.s_id=bbb.s_id --此时过滤出了所有有学过01的s_id了，其中包括有学过02的和没学过02的
where bbb.s_id is null;  -- 选中所有没学过02的

select student.* from student
                          join (select s_id from score where c_id =1 )tmp1
                               on student.s_id=tmp1.s_id
                          left join (select s_id from score where c_id =2 )tmp2
                                    on student.s_id =tmp2.s_id
where tmp2.s_id is null;
-- – 11、查询没有学全所有课程的同学的信息:
-- –先查询出课程的总数量
select * from student join (select sum(1+1)as result1,sum(1+2)as result2); //这相当于增加了字段

//先从课程维度表中求出课程总数num，join进student表里，再在score表中根据s_id分组求出得分了的课程数s_num  然后再将两表进行join求出s_num和num不相等的学生的详细信息
select student.* from student
    join (select count(*)num from course)t1 --这就相当于增加了字段num
    join (select s_id,count(*)s_num from score group by s_id)t2 on student.s_id=t2.s_id
where s_num != t1.num order by s_id;

select student.*
from student join(select count(c_id)sl from course)aaa
             left join (select s_id, count(c_id) num from score group by s_id)bbb
                       on student.s_id=bbb.s_id and aaa.sl=bbb.num
where bbb.s_id is null;

select count(1) from course;
-- –再查询所需结果

select student.* from student
                          left join(
    select s_id
    from score
    group by s_id
    having count(c_id)=3)tmp
                                   on student.s_id=tmp.s_id
where tmp.s_id is null;
-- –方法二(一步到位):

select student.* from student
                  join (select count(c_id)num1 from course)tmp1 //先求出所有课程的总数
                  left join(select s_id,count(c_id)num2 from score group by s_id)tmp2 //左外连接s_id 和 课程总数
                    on student.s_id=tmp2.s_id and tmp1.num1=tmp2.num2
where tmp2.s_id is null;

-- – 12、查询至少有一门课与学号为"01"的同学所学相同的同学的信息:   如果条件为至少有两门呢 至少有n门呢？
-- select c_id from score where s_id ='01'
-- select '01' in (select c_id from score where s_id ='01');
-- select `array`(1,2,3)
-- select `array`('01,02,03')
-- select * from student join score on student.s_id=score.s_id;
-- select `array`(select c_id from score where s_id ='01');
-- select s_id,`array`(select concat_ws(',',collect_list(c_id)) from score where s_id ='01')as aaa from student;

(select concat_ws(',',collect_list(c_id)) from score where s_id ='01')

select student.* --这里写student.*是为了group by
from student join (select c_id from score where s_id='01')aaa --这一步形成笛卡尔积
             join (select s_id,c_id from score)bbb
                  on student.s_id=bbb.s_id and aaa.c_id=bbb.c_id --学号和成绩相等，08号没有成绩，这一步将08号学生去掉了  至少有一门的条件也是在这里过滤的
where bbb.s_id not in('01') --这一步将01排除了
group by student.s_id,student.s_birth,student.s_name,student.s_sex; --因为之前的笛卡尔积，所以这里需要分组将笛卡尔积去掉

select student.* from student
      join (select c_id from score where score.s_id=01)tmp1
      join (select s_id,c_id from score)tmp2
           on tmp1.c_id =tmp2.c_id and student.s_id =tmp2.s_id
where student.s_id  not in('01')
group by student.s_id,s_name,s_birth,s_sex;
-- – 13、查询和"01"号的同学学习的课程完全相同的其他同学的信息:
-- 将01号同学的所有的课程成绩的id通过|连接在一起形成字段a， 然后将其他同学的成绩的科目也通过|连接起来形成字段b，然后最后两表join on a=b
-- –备注:hive不支持group_concat方法,可用 concat_ws(’|’, collect_set(str)) 实现
select student.*,t1.course_id from student join (select s_id,concat_ws('|',collect_set(c_id)) course_id from score group by s_id) t1 on student.s_id=t1.s_id
                    join (select concat_ws('|',collect_set(c_id))course_id2 from score where s_id=1)t2 on t1.course_id=t2.course_id2;


select student.*,tmp1.course_id from student
    join (select s_id ,concat_ws('|', collect_set(c_id)) course_id from score
       group by s_id having s_id not in (1))tmp1
      on student.s_id = tmp1.s_id
    join (select concat_ws('|', collect_set(c_id)) course_id2
       from score  where s_id=1)tmp2
      on tmp1.course_id = tmp2.course_id2;
-- – 14、查询没学过"张三"老师讲授的任一门课程的学生姓名:
-- t1为求出张三的课的c_id,t2为求出有张三所上课程c_id的成绩的学生的c_id，
-- 最后用学生表left join这个t2,求出t2.s_id为null的学生(即学生表中有数据，而t2中没数据的那些学生就是没上过张三老师课的学生)
select student.*
    from student left join
    (select s_id from score join
        (select c_id from course join teacher on course.t_id=teacher.t_id and t_name='张三')t1
    on score.c_id=t1.c_id)t2
    on student.s_id=t2.s_id
where t2.s_id is null;


select student.* from student
left join (select s_id from score
  join (select c_id from course join  teacher on course.t_id=teacher.t_id and t_name='张三')t1
       on score.c_id=t1.c_id )t2
        on student.s_id = t2.s_id
where t2.s_id is null;
-- – 15、查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩:

select student.s_id,student.s_name,tmp.avg_score from student
  inner join (select s_id from score
              where s_score<60
              group by score.s_id having count(s_id)>1)tmp2
             on student.s_id = tmp2.s_id
  left join (
    select s_id,round(AVG (score.s_score)) avg_score
    from score group by s_id)tmp
    on tmp.s_id=student.s_id;
-- – 16、检索"01"课程分数小于60，按分数降序排列的学生信息:

select student.*,s_score from student,score
where student.s_id=score.s_id and s_score<60 and c_id='01'
order by s_score desc;
-- – 17、按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩:

select a.s_id,tmp1.s_score as chinese,tmp2.s_score as math,tmp3.s_score as english,
       round(avg (a.s_score),2) as avgScore
from score a
         left join (select s_id,s_score  from score s1 where  c_id='01')tmp1 on  tmp1.s_id=a.s_id
         left join (select s_id,s_score  from score s2 where  c_id='02')tmp2 on  tmp2.s_id=a.s_id
         left join (select s_id,s_score  from score s3 where  c_id='03')tmp3 on  tmp3.s_id=a.s_id
group by a.s_id,tmp1.s_score,tmp2.s_score,tmp3.s_score order by avgScore desc;
-- – 18.查询各科成绩最高分、最低分和平均分：以如下形式显示：课程ID，课程name，最高分，最低分，平均分，及格率，中等率，优良率，优秀率:
-- –及格为>=60，中等为：70-80，优良为：80-90，优秀为：>=90

select course.c_id,course.c_name,tmp.maxScore,tmp.minScore,tmp.avgScore,tmp.passRate,tmp.moderate,tmp.goodRate,tmp.excellentRates from course
join(select c_id,max(s_score) as maxScore,min(s_score)as minScore,
           round(avg(s_score),2) avgScore,
           round(sum(case when s_score>=60 then 1 else 0 end)/count(c_id),2)passRate,
           round(sum(case when s_score>=60 and s_score<70 then 1 else 0 end)/count(c_id),2) moderate,
           round(sum(case when s_score>=70 and s_score<80 then 1 else 0 end)/count(c_id),2) goodRate,
           round(sum(case when s_score>=80 and s_score<90 then 1 else 0 end)/count(c_id),2) excellentRates
    from score group by c_id)tmp on tmp.c_id=course.c_id;
-- – 19、按各科成绩进行排序，并显示排名:
-- – row_number() over()分组排序功能(mysql没有该方法)

-- select s1.*,row_number()over(order by s1.s_score desc) Ranking
-- from score s1 where s1.c_id='01'order by noRanking asc
--     union all select s2.*,row_number()over(order by s2.s_score desc) Ranking
--               from score s2 where s2.c_id='02'order by noRanking asc
--                   union all select s3.*,row_number()over(order by s3.s_score desc) Ranking
--                             from score s3 where s3.c_id='03'order by noRanking asc;
-- – 20、查询学生的总成绩并进行排名:

select score.s_id,s_name,sum(s_score) sumscore,row_number()over(order by sum(s_score) desc) Ranking
from score ,student
where score.s_id=student.s_id
group by score.s_id,s_name order by sumscore desc;
-- – 21、查询不同老师所教不同课程平均分从高到低显示:
-- – 方法1

select course.c_id,course.t_id,t_name,round(avg(s_score),2)as avgscore from course
    join teacher on teacher.t_id=course.t_id
    join score on course.c_id=score.c_id
group by course.c_id,course.t_id,t_name order by avgscore desc;
-- – 方法2

select course.c_id,course.t_id,t_name,round(avg(s_score),2)as avgscore from course,teacher,score
where teacher.t_id=course.t_id and course.c_id=score.c_id
group by course.c_id,course.t_id,t_name order by avgscore desc;
-- – 22、查询所有课程的成绩第2名到第3名的学生信息及该课程成绩:

-- select tmp1.* from
--     (select * from score where c_id='01' order by s_score desc limit 3)tmp1
-- order by s_score asc limit 2
-- union all select tmp2.* from
--     (select * from score where c_id='02' order by s_score desc limit 3)tmp2
--           order by s_score asc limit 2
--           union all select tmp3.* from
--     (select * from score where c_id='03' order by s_score desc limit 3)tmp3
--                     order by s_score asc limit 2;
-- – 23、统计各科成绩各分数段人数：课程编号,课程名称,[100-85],[85-70],[70-60],[0-60]及所占百分比

select c.c_id,c.c_name,tmp1.s0_60, tmp1.percentum,tmp2.s60_70, tmp2.percentum,tmp3.s70_85, tmp3.percentum,tmp4.s85_100, tmp4.percentum
from course c
 join(select c_id,sum(case when s_score<60 then 1 else 0 end )as s0_60,
             round(100*sum(case when s_score<60 then 1 else 0 end )/count(c_id),2)as percentum
      from score group by c_id)tmp1 on tmp1.c_id =c.c_id
 left join(select c_id,sum(case when s_score<70 and s_score>=60 then 1 else 0 end )as s60_70,
                  round(100*sum(case when s_score<70 and s_score>=60 then 1 else 0 end )/count(c_id),2)as percentum
           from score group by c_id)tmp2 on tmp2.c_id =c.c_id
 left join(select c_id,sum(case when s_score<85 and s_score>=70 then 1 else 0 end )as s70_85,
                  round(100*sum(case when s_score<85 and s_score>=70 then 1 else 0 end )/count(c_id),2)as percentum
           from score group by c_id)tmp3 on tmp3.c_id =c.c_id
 left join(select c_id,sum(case when s_score>=85 then 1 else 0 end )as s85_100,
                  round(100*sum(case when s_score>=85 then 1 else 0 end )/count(c_id),2)as percentum
           from score group by c_id)tmp4 on tmp4.c_id =c.c_id;
-- – 24、查询学生平均成绩及其名次:

select tmp.*,row_number()over(order by tmp.avgScore desc) Ranking from
    (select student.s_id,
            student.s_name,
            round(avg(score.s_score),2) as avgScore
     from student join score
                       on student.s_id=score.s_id
     group by student.s_id,student.s_name)tmp
order by avgScore desc;
-- – 25、查询各科成绩前三名的记录

-- –课程id为01的前三名

select score.c_id,course.c_name,student.s_name,s_score from score
    join student on student.s_id=score.s_id
    join course on  score.c_id='01' and course.c_id=score.c_id
order by s_score desc limit 3;
-- –课程id为02的前三名

select score.c_id,course.c_name,student.s_name,s_score
from score
     join student on student.s_id=score.s_id
     join course on  score.c_id='02' and course.c_id=score.c_id
order by s_score desc limit 3;
-- –课程id为03的前三名

select score.c_id,course.c_name,student.s_name,s_score
from score
         join student on student.s_id=score.s_id
         join course on  score.c_id='03' and course.c_id=score.c_id
order by s_score desc limit 3;
-- – 26、查询每门课程被选修的学生数:

select c.c_id,c.c_name,tmp.number from course c
       join (select c_id,count(1) as number from score
             where score.s_score<60 group by score.c_id)tmp
            on tmp.c_id=c.c_id;
-- – 27、查询出只有两门课程的全部学生的学号和姓名:

select st.s_id,st.s_name from student st
      join (select s_id from score group by s_id having count(c_id) =2)tmp
           on st.s_id=tmp.s_id;
-- – 28、查询男生、女生人数:

select tmp1.man,tmp2.women from
        (select count(1) as man from student where s_sex='男')tmp1,
        (select count(1) as women from student where s_sex='女')tmp2;
-- – 29、查询名字中含有"风"字的学生信息:

select * from student where s_name like '%风%';
-- – 30、查询同名同性学生名单，并统计同名人数:

select s1.s_id,s1.s_name,s1.s_sex,count(*) as sameName
from student s1,student s2
where s1.s_name=s2.s_name and s1.s_id<>s2.s_id and s1.s_sex=s2.s_sex
group by s1.s_id,s1.s_name,s1.s_sex;
-- – 31、查询1990年出生的学生名单:
select * from student where year(s_birth) = '1990';

select * from student where s_birth like '1990%';
-- – 32、查询每门课程的平均成绩，结果按平均成绩降序排列，平均成绩相同时，按课程编号升序排列:
select score.c_id,c_name,round(avg(s_score),2) as avgScore from score
                            join course on score.c_id=course.c_id
group by score.c_id,c_name order by avgScore desc,score.c_id asc;
-- – 33、查询平均成绩大于等于85的所有学生的学号、姓名和平均成绩:

select score.s_id,s_name,round(avg(s_score),2)as avgScore from score
                                                                   join student on student.s_id=score.s_id
group by score.s_id,s_name having avg(s_score) >= 85;
-- – 34、查询课程名称为"数学"，且分数低于60的学生姓名和分数:

select s_name,s_score as mathScore from student
        join (select s_id,s_score
              from score,course
              where score.c_id=course.c_id and c_name='数学')tmp
             on tmp.s_score < 60 and student.s_id=tmp.s_id;
-- – 35、查询所有学生的课程及分数情况:

select a.s_name,
       SUM(case c.c_name when '语文' then b.s_score else 0 end ) as chainese,
       SUM(case c.c_name when '数学' then b.s_score else 0 end ) as math,
       SUM(case c.c_name when '英语' then b.s_score else 0 end ) as english,
       SUM(b.s_score) as sumScore
from student a
         join score b on a.s_id=b.s_id
         join course c on b.c_id=c.c_id
group by s_name,a.s_id;
-- – 36、查询任何一门课程成绩在70分以上的学生姓名、课程名称和分数:

select student.s_id,s_name,c_name,s_score from student
       join (select sc.* from score sc
          left join(select s_id from score where s_score < 70 group by s_id)tmp
           on sc.s_id=tmp.s_id where tmp.s_id is null)tmp2
            on student.s_id=tmp2.s_id
       join course on tmp2.c_id=course.c_id
order by s_id;


-- **-- 查询全部及格的信息**
select sc.* from score sc
     left join(select s_id from score where s_score < 60 group by s_id)tmp
      on sc.s_id=tmp.s_id
where  tmp.s_id is  null;
-- **-- 或(效率低)**
select sc.* from score sc
where sc.s_id not in (select s_id from score where s_score < 60 group by s_id);

-- – 37、查询课程不及格的学生:

select s_name,c_name as courseName,tmp.s_score
from student
 join (select s_id,s_score,c_name
       from score,course
       where score.c_id=course.c_id and s_score < 60)tmp
      on student.s_id=tmp.s_id;
-- –38、查询课程编号为01且课程成绩在80分以上的学生的学号和姓名:

select student.s_id,s_name,s_score as score_01
from student
    join score on student.s_id=score.s_id
where c_id='01' and s_score >= 80;
-- – 39、求每门课程的学生人数:

select course.c_id,course.c_name,count(1)as selectNum
from course
         join score on course.c_id=score.c_id
group by course.c_id,course.c_name;
-- – 40、查询选修"张三"老师所授课程的学生中，成绩最高的学生信息及其成绩:

select student.*,tmp3.c_name,tmp3.maxScore
from (select s_id,c_name,max(s_score)as maxScore from score
  join (select course.c_id,c_name from course join
       (select t_id,t_name from teacher where t_name='张三')tmp
       on course.t_id=tmp.t_id)tmp2
       on score.c_id=tmp2.c_id group by score.s_id,c_name
      order by maxScore desc limit 1)tmp3
         join student
              on student.s_id=tmp3.s_id;
-- – 41、查询不同课程成绩相同的学生的学生编号、课程编号、学生成绩:

select distinct a.s_id,a.c_id,a.s_score from score a,score b
where a.c_id <> b.c_id and a.s_score=b.s_score;
-- – 42、查询每门课程成绩最好的前三名:

select tmp1.* from
    (select *,row_number()over(order by s_score desc) ranking
     from score  where c_id ='01')tmp1
where tmp1.ranking <= 3
union all
select tmp2.* from
    (select *,row_number()over(order by s_score desc) ranking
     from score where c_id ='02')tmp2
where tmp2.ranking <= 3
union all
select tmp3.* from
    (select *,row_number()over(order by s_score desc) ranking
     from score where c_id ='03')tmp3
where tmp3.ranking <= 3;

-- – 43、统计每门课程的学生选修人数（超过5人的课程才统计）:
-- – 要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排列

select distinct course.c_id,tmp.num from course
    join (select c_id,count(1) as num from score group by c_id)tmp
where tmp.num>=5 order by tmp.num desc ,course.c_id asc;
-- – 44、检索至少选修两门课程的学生学号:

select s_id,count(c_id) as totalCourse
from score
group by s_id
having count(c_id) >= 2;

-- – 45、查询选修了全部课程的学生信息:

select student.*
from student,
     (select s_id,count(c_id) as totalCourse
      from score group by s_id)tmp
where student.s_id=tmp.s_id and totalCourse=3;

-- –46、查询各学生的年龄(周岁):
-- – 按照出生日期来算，当前月日 < 出生年月的月日则，年龄减一
-- 方法一

select s_name,s_birth,
       (year(CURRENT_DATE)-year(s_birth)-
        (case when month(CURRENT_DATE) < month(s_birth) then 1
              when month(CURRENT_DATE) = month(s_birth) and day(CURRENT_DATE) < day(s_birth) then 1
              else 0 end)
           ) as age
from student;
-- 方法二:

select s_name,s_birth,
       floor((datediff(current_date,s_birth) - floor((year(current_date) - year(s_birth))/4))/365) as age
from student;

-- – 47、查询本周过生日的学生:
-- –方法1

select * from student where weekofyear(CURRENT_DATE)+1 =weekofyear(s_birth);
-- –方法2

select s_name,s_sex,s_birth from student
where substring(s_birth,6,2)='10'
  and substring(s_birth,9,2)=14;
-- – 48、查询下周过生日的学生:
-- –方法1

select * from student where weekofyear(CURRENT_DATE)+1 =weekofyear(s_birth);
-- –方法2

select s_name,s_sex,s_birth from student
where substring(s_birth,6,2)='10'
  and substring(s_birth,9,2)>=15
  and substring(s_birth,9,2)<=21;
-- – 49、查询本月过生日的学生:
-- –方法1

select * from student where MONTH(CURRENT_DATE) =MONTH(s_birth);
-- –方法2

select s_name,s_sex,s_birth from student where substring(s_birth,6,2)='10';
-- – 50、查询12月份过生日的学生:

select s_name,s_sex,s_birth from student where substring(s_birth,6,2)='12';   --sunstring(s_birth,6,2) 截取s_birth字符串，从位置6开始，往后2个



-- 51找出所有科目成绩都大于每个学科平均成绩的学生


-- 这种方式存在的问题:如果有的人的科目没有分数，那么这个人将不会被统计，因为标签数量不全 （这个标签是符合标签）
select s_id
from (
         select s_id,if(s_score>avg,1,0) flag
         from(
                 select  s_id,s_score,avg(s_score)  over (partition by c_id)  avg from score) t1)t2
group by s_id
having sum(flag)=3;


-- 这种方式存在的问题:如果有的人的科目没有分数，那么这个人也会被统计进去，因为没有出现不符合的标签   （这个标签是非符合标签）
select s_id
from (select s_id,if(s_score > avg_score, 0, 1) flag
      from
          (select s_id,
                  s_score,
                  avg(s_score) over (partition by c_id) avg_score
           from score
          ) t1
     ) t2
group by s_id
having sum(flag) = 0;


-- 这种方式是 先求出学生各科成绩的最小值将其与各科平均成绩中的最大值做比较，取u_id   存在的问题:如果一个学生有一些科目没有成绩的话，最小成绩究竟算有成绩的最小，还是0？
SELECT s_id,min FROM
    (SELECT s_id,min(s_score) as min from score GROUP BY s_id) t2 where min >=
(select max(avg)
   from(select s_id,AVG(s_score) avg FROM score GROUP BY c_id) t1)

