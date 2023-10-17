declare
    type c_ty is ref cursor;
    type t_ty is table of movie.title%type;
    csr c_ty;
    tts t_ty := t_ty('and', 'or', 'of', 'love');
    avg_q varchar2(200) := 'select avg(length) from movie where title like ''%''||:1||''%'' ';
    sql_q varchar2(200) := 'select * from movie where title like ''%''||:1||''%'' ';
    m movie%rowtype;
    avg_len float;
begin
    for i in tts.first .. tts.last loop
        execute immediate avg_q into avg_len using tts(i);
        dbms_output.put_line('* '||tts(i)||'가 제목에 들어간 영화들 : 평균 상영시간-'||avg_len||'분');
    end loop;
end;