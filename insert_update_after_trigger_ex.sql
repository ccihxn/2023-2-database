create or replace trigger movieexec_trigger after insert or update on movieexec for each row
declare
    c_no integer;
    cnt integer;
    avg_n movieexec.networth%type;
begin
    if :new.name is null then
        update movieexec
        set name = 'DUMMY_'||:new.certno
        where certno = :new.certno;
    end if;
end;
