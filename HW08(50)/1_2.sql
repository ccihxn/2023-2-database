create or replace trigger movieexec_insert before insert or update on movieexec for each row
declare

begin
    if :new.certno is null then
        select max(certno) into :new.certno from movieexec;
        :new.certno := :new.certno + 1;
    end if;
    if :new.name is null then
        :new.name := 'newExec'||:new.certno;
    end if;
    if :new.address is null then
        select address into :new.address
        from (select address
        from moviestar
        where gender = 'male'
        order by dbms_random.value)
        where rownum = 1;
    end if;
    if :new.networth is null then
        select networth into :new.networth
        from movieexec
        where certno = (select producerno from 
        (select producerno from movie group by producerno having count(*) = 
        (select min(prod_count) from
        (select count(*) as prod_count from movie group by producerno))
        order by dbms_random.value)
        where rownum = 1);
    end if;
end;