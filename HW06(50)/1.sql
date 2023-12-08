declare
    query1 varchar2(200) := 'insert into studioinfo values (:1, :2, :3, movie_tab(), star_tab())';
    movie_query varchar2(200) := 'insert into table(select movies from studioinfo where name = :1) values (mv_ty(:2, :3, :4, :5))';
    star_query varchar2(200) := 'insert into table(select stars from studioinfo where name = :1) values (star_ty(:2, :3, :4))';
    cursor movie_cursor(pres studio.presno%type) is select * from movie where producerno = pres;
    cursor star_cursor is select * from moviestar where rownum <= dbms_random.value(1, 12) order by dbms_random.value;
    producername movieexec.name%type;
    movie_row movie%rowtype;
    cnt integer;
begin
    for s in  (select s.name sname, s.address saddress, s.presno spresno, m.name mname, m.address maddress, m.certno mcertno, m.networth mnetworth from studio s, movieexec m where s.presno = m.certno) loop
        execute immediate query1 using s.sname, s.saddress, s.mname;
        select count(title) into cnt from movie where s.spresno = producerno;
        for m in movie_cursor(s.spresno) loop
                select name into producername from movieexec where s.spresno = certno;
                execute immediate movie_query using s.sname, m.title, m.year, dbms_random.value(10000, 10000000), producername;
        end loop;
        for star in star_cursor loop
            execute immediate star_query using s.sname, star.name, dbms_random.value(10000, 100000000), dbms_random.value(1, 99);
        end loop;
    end loop;
end;