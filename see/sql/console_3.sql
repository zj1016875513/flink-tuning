
desc function positive;
desc function space;

use exercrise_50;
select movie,cc from movie_info lateral view explode(split(category,',')) aaa as cc;
select movie,cc from movie_info posexplode_outer(split(category,',')) aaa as cc;



select movie,posexplode_outer(split(category,',')) from movie_info;
select movie,posexplode(split(category,',')) from movie_info;


select space(datediff('2020-11-30', '2020-11-01'));


select type,name,aa_type,bb_name from person_info1
lateral view posexplode(split(type,'_')) aa as aa_index,aa_type
lateral view posexplode(split(name,'_')) bb as bb_index,bb_name
where aa_index=bb_index











