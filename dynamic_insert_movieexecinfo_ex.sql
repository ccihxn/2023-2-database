declare
    sql_e varchar2(200) := 'insert into movieexecinfo values (:1, :2, :3, movie_tab(), studio_tab())';
    sql_m varchar2(200) := 'insert into table(select movies from movieexecinfo where name = :1) values (movie_ty(:2, :3, :4, :5))';
    sql_s varchar2(200) := 'insert into table(select studios from movieexecinfo where name = :1) values (studio_ty(:2, :3))';
    cursor mvs(cno movieexec.certno%type) is select * from movie where producerno = cno;
    cursor stds(cno movieexec.certno%type) is select * from studio where presno = cno;
begin
    for e in (select * from movieexec) loop
        execute immediate sql_e using e.name, e.address, e.networth;
        for m in mvs(e.certno) loop
            execute immediate sql_m using e.name, m.title, m.year, to_date('2000-01-01') + dbms_random.value(1, 22 * 365), dbms_random.value(1000000, 10000000000);
        end loop;
        
        for s in stds(e.certno) loop
            execute immediate sql_s using e.name, s.name, dbms_random.value(10, 100);
        end loop;
    end loop;
end;