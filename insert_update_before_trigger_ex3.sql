create or replace trigger studio_trigger before insert or update on studio for each row
declare
    c_no integer;
    avg_n movieexec.networth%type;
    cnt integer;
    pragma autonomous_transaction;
begin
    if :new.address is null then
       :new.address := 'DUMMY_'||:new.name;
    end if;
    if :new.presno is null then
        select certno into c_no from (select * from movieexec where certno not in (select presno from studio where presno is not null) order by dbms_random.value) where rownum = 1;
        :new.presno := c_no;
    end if;
end;