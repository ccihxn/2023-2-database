create or replace trigger movie_trigger before insert or update on movie for each row
declare
    cnt integer;
    avg_len movie.length%type;
    m movie%rowtype;
    pragma autonomous_transaction;
begin
    select * into m from movie
    where :new.title = title and :new.year = year;
    --raise_application_error(-2001, 'movie tuple is duplicated');
exception
    when others then
        select avg(length) into avg_len from movie;
        :new.length := avg_len;
        select count(*) into cnt from studio
        where :new.studioname = name;
        if cnt = 0 then
            insert into studio(name) values (:new.studioname);
            commit;
        end if;
end;