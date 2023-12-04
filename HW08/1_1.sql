create or replace trigger movie_insert before insert or update on movie for each row
declare
    avg_length movie.length%type;
    cnt integer;
begin
    if :new.length is null then
        select avg(length) into avg_length from movie;
        :new.length := avg_length;
    end if;
    if :new.incolor is null then
        :new.incolor := 't';
    end if;
    if :new.studioname is null then
        select studioname into :new.studioname from 
        (select studioname from movie group by studioname having count(*) = 
        (select min(studio_count) from
        (select count(*) as studio_count from movie group by studioname))
        order by dbms_random.value)
        where rownum = 1;
    end if;
    if :new.producerno is null then
        select certno into :new.producerno
        from (select *
        from movieexec
        order by dbms_random.value)
        where rownum = 1;
    end if;
end;