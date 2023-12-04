insert into movie(title, year, studioname) values ('X1', 2022, 'X1');
insert into movie(title, year, studioname) values ('X1', 2022, 'X2');
insert into movie(title, year, studioname) values ('X2', 2022, 'X4');
insert into movie(title, year, studioname) values ('X2', 2022, 'X5');
insert into movie(title, year, studioname) values ('X2', 2022, 'X6');


update movie
set studioname = 'X3'
where year = 2022;

select * from movie where year = 2022;
select * from studio where name like 'X%';