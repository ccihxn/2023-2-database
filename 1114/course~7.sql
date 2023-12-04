insert into movieprod values('star wars', 1977, 'sharky');
insert into movieprod values('star wars', 1977, 'X1');
insert into movieprod values('X1', 2022, 'X1');
insert into movieprod values('X2', 2022, 'X2');


update movieprod
set prod = 'smile kang'
where title = 'star wars' and year = 1977;

update movieprod
set prod = 'X2'
where title = 'star wars' and year = 1977;

update movieprod
set prod = 'X4'
where title = 'X3' and year = 2022;

update movieprod
set title = 'X3', year = 2022
where prod = 'X4';

update movieprod
set title = 'X3', year = 2022
where prod = 'X3';

select * from movieexec;
select * from movieprod;
select * from movieprod where prod like 'X%';
select *from movieexec where name like 'X%';

delete from movieprod
where prod like 'X%';