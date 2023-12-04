create or replace trigger movie_trigger before insert on movie for each row
declare
    avg_l integer;
begin
    if :new.length is null then
        select avg(length) into avg_l from movie;
        :new.length := avg_l;
    end if;
end;