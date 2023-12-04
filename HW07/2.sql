create or replace trigger Exec_Update before insert or update on movieexec for each row
declare
    cnt_studio integer;
    cnt_movie integer;
    cnt integer;
    max_networth movieexec.networth%type;
    avg_networth movieexec.networth%type;
    pres movieexec.certno%type;
    pragma autonomous_transaction;
begin
    select count(name) into cnt_studio from studio where presno = :new.certno;
    select count(title) into cnt_movie from movie where producerno = :new.certno;
    if cnt_studio > 0 or cnt_movie > 0 then
        :new.name := :old.name;
    elsif cnt_studio = 0 and cnt_movie = 0 then
        select avg(networth) into avg_networth from movieexec;
        if :new.networth > avg_networth then
            insert into movieexec(certno)  values (:new.certno);
            select presno into pres from (select * from studio order by dbms_random.value) where rownum = 1;
            update studio
            set presno = :new.certno
            where presno = pres;
            commit;
        end if;
    end if;
    if :new.networth is null then
        select max(networth) into max_networth from movieexec;
        :new.networth := max_networth;
    end if;
    select count(starname) into cnt from movieexec, starsin where name = :new.name and name = starname;
    if cnt > 0 then
        :new.address := :new.address||'에 배우가 삽니다!';
    end if;
end;