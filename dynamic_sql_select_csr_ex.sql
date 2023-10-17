declare
    type c_ty is ref cursor;
    type t_ty is table of movie.title%type;
    csr c_ty;
    tts t_ty := t_ty('and', 'or', 'of', 'love', '%');
    avg_q varchar2(200) := 'select avg(length) from movie where title like ';
    sql_q varchar2(200) := 'select * from movie where title like ';
    m movie%rowtype;
    avg_len float;
    whr varchar2(100);
begin
    for i in tts.first .. tts.last loop
        if tts(i) = '%' then
            whr := ' ''%K''||:1||''%''  escape ''K'' ';
        else
            whr := ' ''%''||:1||''%'' ';
        end if;
        execute immediate avg_q||whr into avg_len using tts(i);
        dbms_output.put_line('* '||tts(i)||'가 제목에 들어간 영화들 : 평균 상영시간-'||avg_len||'분');
        open csr for sql_q||whr using tts(i);
        loop
            fetch csr into m;
            exit when csr%notfound;
            dbms_output.put_line(lpad('- ', 5)||m.title||'('||m.year||')');
        end loop;
        close csr;
    end loop;
end;