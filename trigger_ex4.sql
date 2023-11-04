create or replace TRIGGER begore_movie
before insert on movie
for each row
declare
    avg_len movie.length%type;
begin
    select avg(length) into avg_len from movie;
    if :new.length is null then
        :new.length := 99;
    end if;
    if :new.incolor is null then
        :new.incolor := 't';
    end if;
    if :new.studioname is null then
        :new.studioname := 'disney';
    elsif (select count(name) from studio where name = :new.studioname) = 0 then
        insert into studio(name) values (:new.studioname);
    end if;
end;