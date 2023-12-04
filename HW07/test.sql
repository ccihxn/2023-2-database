select trunc(avg(networth))
from movieexec;

insert into movieexec(name, certno, networth) values ('전지환',40, 6000000000);

insert into movieexec(name, certno, networth) values ('leeese',500,100000);

select presno from (select * from studio order by dbms_random.value) where rownum = 1;

update movieexec
set certno = 70
where name = '전지환';

update movieexec
set name = '1234'
where name = 'george lucas';

select count(*)
from studio
where presno = 38;

select max(networth)
from movieexec;

select *
from movieexec;

select *
from studio;

update movieexec
set networth = null
where name = 'sharky';

select *
from movieexec

minus

(select movieexec.*
from movieexec, movie
where certno = producerno
union all

select movieexec.*
from movieexec, studio
where certno = presno);


update movieexec
set name = '전지환'
where name = 'denis villeneuve';


select *
from movieexec, starsin
where name = starname;

update movieexec
set address = 'butch cassidy and the sundance kid';