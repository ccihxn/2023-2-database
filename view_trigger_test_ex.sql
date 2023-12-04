insert into movieexec(certno) values (54);

update movieexec
set name =  null where certno = 51;

select * from fox_movies;

insert into fox_movies values ('X2', 2022);

insert into fox_movies values ('X4', 2022, 'mgm');

insert into fox_movies values ('X11', 2022);

update fox_movies
set studioname = 'mgm'
where title = 'X3';

select * from movieprod