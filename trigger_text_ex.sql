insert into movie(title, year) values ('X1', 2022);
insert into movie(title, year) values ('X2', 2022);
insert into movie(title, year, studioname) values ('X3', 2022, 'ABC');
insert into movie(title, year, producerno) values ('X4', 2022, 60);
insert into movie(title, year, length) values ('X3', 2022, 99);
insert into movie(title, year) values ('X4', 2022);
insert into movie(title, year) values ('X5', 2022);
insert into movie(title, year, length) values ('X6', 2022, 199);
insert into movie(title, year, studioname) values ('X5', 2022, null);
insert into movie(title, year, studioname) values ('X8', 2022, null);
insert into movie(title, year, studioname) values ('X9', 2022, null);
insert into movie(title, year, studioname) values ('X10', 2022, 'XYZ');
insert into movieexec(certno) values(null);
insert into movieexec(certno) values(1);
insert into studio(name) values ('NEWNEWNNEW');

update movieexec set name = null where certno = 61;

update movie
set length = null where title = 'X3';

update movie
set length = 120 where title = 'X4';

update movie 
set studioname = null where title = 'X7';

update movie
set producerno = null where title = 'X4';

select * from movie where year = 2022;

select * from studio;

select * from movieexec;

select * from movieexec where certno not in (select producerno from movie where producerno is not null);

--error -4091 해결 : 테이블이 변경되어 트리거/함수가 볼 수 없습니다.