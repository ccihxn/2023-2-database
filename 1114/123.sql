create or replace trigger movie_trigger before insert on movie for each row
declare
begin
    select avg(length) into :new.length from movie;
    select name into :new.studioname from (select name from studio order by dbms_random.value) where rownum = 1;
    :new.incolor := 't';
end;