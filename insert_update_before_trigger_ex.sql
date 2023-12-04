create or replace trigger movie_trigger before insert or update on movie for each row
declare
    avg_l integer;
    cnt integer;
    s_name studio.name%type;
    c_no movieexec.certno%type;
    pragma autonomous_transaction;
begin

    if :new.length < :old.length then
        :new.length := :old.length;
    end if;
    
    if :new.length is null then
        select avg(length) into avg_l from movie;
        :new.length := avg_l;
    end if;
    
    if :new.studioname is null then
        select name into s_name from (select * from studio order by dbms_random.value) where rownum = 1;
        :new.studioname := s_name;
        
    else
        select count(*) into cnt from studio where name = :new.studioname;
        if cnt = 0 then
            insert into studio(name) values (:new.studioname);
            commit;
        end if;
    end if;
    
    if :new.producerno is null then
        select certno into c_no from (select * from movieexec where certno not in (select producerno from movie where producerno is not null) order by dbms_random.value) where rownum = 1;
        :new.producerno := c_no;
        
    else
        begin
            select certno into c_no from movieexec where certno = :new.producerno;
        exception
            when others then
                insert into movieexec(certno) values (:new.producerno);
                commit;
        end;
    end if;
    
end;