declare
    type csr_ty is ref cursor;
    type t_ty is table of varchar2(50);
    csr csr_ty;
    t_names t_ty := t_ty('BABO', 'Movie', 'Student');
    sql_q varchar2(200) := 'select * from user_tables where ';
    t user_tables%rowtype;
begin
    for i in t_names.first .. t_names.last loop
        sql_q := sql_q||'table_name like '''||t_names(i)||'%'' ';
        if i < t_names.last then
            sql_q := sql_q||' or ';
        end if;
    end loop;
    open csr for sql_q;
    loop
        fetch csr into t;
        exit when csr%notfound;
        begin
            execute immediate 'drop table '||t.table_name;
            dbms_output.put_line('테이블 '||t.table_name||' 삭제 됨.');
        exception
            when others then 
                dbms_output.put_line('테이블 '||t.table_name||'은 삭제 불가.');
        end;
    end loop;
    close csr;
end;