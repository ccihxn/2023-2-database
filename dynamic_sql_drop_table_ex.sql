declare
    type t_ty is table of varchar2(50);
    t_names t_ty := t_ty('BABO', 'Movie', 'Student');
    sql_q varchar2(200) := 'drop table ';
    tn varchar2(50);
begin
    for t in (select * from user_tables) loop
        for i in t_names.first .. t_names.last loop
            if t.table_name like upper(t_names(i))||'%' then
                execute immediate 'drop table '||t.table_name;
                dbms_output.put_line('테이블 '||t.table_name||' 삭제 됨.');
            end if;
        end loop;
    end loop;
end;