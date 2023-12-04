create or replace trigger movieexec_trigger before insert or update on movieexec for each row
declare
    c_no movieexec.certno%type;
    avg_n movieexec.networth%type;
    cnt integer;
    pragma autonomous_transaction;
begin
    select count(*) into cnt from movieexec where certno = :new.certno;
    if :new.certno  is null or cnt > 0 then
        select max(certno) into c_no from movieexec;
        :new.certno := c_no + 1;
    end if;
    if :new.name is null then
       :new.name := 'DUMMY_'||:new.certno;
    end if;
    if :new.networth is null then
        select avg(networth) into avg_n from movieexec;
        :new.networth := avg_n;
    end if;
end;