create or replace trigger moviestar_trigger
after insert or update on moviestar
for each row
declare
    cnt     integer;
    m       movie%rowtype;
    max_birth   moviestar.birthdate%type;
    pragma      autonomous_transaction;
begin
    select max(birthdate) into max_birth from moviestar;
    
    select count(*) into cnt from starsin
    where starname = :new.name;
    
    if cnt = 0 then
        select * into m from (select * from movie order by dbms_random.value) where rownum = 1;
        --insert into starsin values (m.title, m.year, 'harrison ford');
        insert into starsin values (m.title, m.year, :new.name);
        commit;
    end if;
end;