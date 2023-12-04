insert into starplays values ('이현석은 죽었다.', 2023, '이현석');

insert into starplays values ('전지환 천재', 2023, '전지환');

select * from starplays where year = 2023;

select * from moviestar where name = '전지환';

insert into movieprod values ('이현석은 부활했다.', 2023, '전지환');

select * from movieprod where title like '%이현석%';

select * from movie where title like '%이현석%';

select trunc(avg(length)) from movie;

select studioname, count(*) from movie group by studioname having count(*) = (select min(cnt) from (select count(*) cnt from movie group by studioname));

select * from movieexec where name = '전지환';

select * from movieexec order by certno desc;

insert into movieprod (title, year) values ('일어나보니 얼리버드가 되어있던 정부용에 관하여', 2023);

select * from movieprod where title like '%정부용%';

select * from movie where title like '%정부용%';ka

select * from movieexec where certno = (select max(certno) from movieexec);

select * from moviestar where address = 'neptune nj';

select name, networth 
from movieexec 
where certno = (select producerno 
                from movie 
                where rownum = 1
                group by producerno 
                having count(*) = (select min(cnt) 
                                from (select count(*) cnt
                                    from movie 
                                    group by producerno)));
                                    
select networth
        from movieexec
        where certno = (select producerno from 
        (select producerno from movie group by producerno having count(*) = 
        (select min(prod_count) from
        (select count(*) as prod_count from movie group by producerno))
        order by dbms_random.value)
        where rownum = 1);

select name, networth, count(*) from movieexec group by name, networth having count(*) = (select min(cnt) from (select count(*) cnt from movie group by producerno));

select * from moviestar where name like '%이현석%';

select certno
        from (select *
        from movieexec
        order by dbms_random.value)
        where rownum = 1;