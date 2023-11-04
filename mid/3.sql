declare
    type exec_record is record(
        name movieexec.name%type,
        address movieexec.address%type,
        movie_cnt integer,
        studio_cnt integer
    );
    type exec_type is table of exec_record;
    type c_type is ref cursor;
    
    exec_list exec_type;
    csr c_type;
    csr_query varchar2(255) := 'select movieexec.name, movieexec.address, count(producerno), count(presno) from movieexec left join movie on certno = producerno left join studio on certno = presno group by movieexec.name, movieexec.address order by movieexec.name asc';
    csr_fetch varchar2(255) := 'fetch :1 bulk collect into :2';
    dbmsprint varchar2(255) := 'dbms_output.put_line(rpad(:1, 30)||rpad(:2, 60)||lpad(:3||''편'', 30)||lpad(:4||''개'', 30))';
begin
    open csr for csr_query;
        fetch csr bulk collect into exec_list;
    close csr; 
        dbms_output.put_line(lpad(rpad('이름', 15), 30)||lpad(rpad('주소', 30), 60)||lpad(rpad('제작영화 편수', 15), 35)||lpad('운영 영화사 수', 30));
    for i in exec_list.first .. exec_list.last loop
        dbms_output.put(rpad(exec_list(i).name, 30)||rpad(exec_list(i).address, 60));
        if exec_list(i).movie_cnt = 0 then
            dbms_output.put(lpad(rpad('해당사항 없음', 30), 22));
        else
            dbms_output.put(lpad(exec_list(i).movie_cnt||'편', 20));
        end if;
        if exec_list(i).studio_cnt = 0 then
            dbms_output.put_line(lpad('해당사항 없음', 25));
        else
            dbms_output.put_line(lpad(exec_list(i).studio_cnt||'개', 30));
        end if;
    end loop;
end;