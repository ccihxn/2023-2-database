create or replace trigger movieprod_trigger
instead of insert or update or delete on movieprod --view에 대해서만 instead of 사용가능.
for each row
declare
    cnt     integer;
    p_no    movieexec.certno%type;
begin
    if deleting then
        update movie
        set producerno = null
        where title = :old.title and year = :old.year;
    else
        select count(*) into cnt from movie where title = :new.title and year = :new.year;
        if cnt = 0 then
            insert into movie(title, year) values (:new.title, :new.year);
        end if;
        select count(*) into cnt from movieexec where :new.prod = name;
        if cnt = 0 then
            insert into movieexec(name) values (:new.prod);
        end if;
        select certno into p_no from movieexec
        where :new.prod = name;
        update movie
        set producerno = p_no
        where title = :new.title and year = :new.year;
    end if;
end;