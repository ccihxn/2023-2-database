insert into moviestar(name) values ('X1');
insert into moviestar(name) values ('X2');

update moviestar
set name = 'joon-hun park'
where name = 'joon-hun park';

select * from moviestar where name not in (select starname from starsin);
select * from starsin;