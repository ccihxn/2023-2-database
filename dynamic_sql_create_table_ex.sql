declare
    type t_ty is table of varchar2(50);
    t_names t_ty := t_ty('BABO', 'Movie', 'Student');
    attrs varchar2(100) := '(name varchar2(50), age number(3))';
    sql_q varchar2(200) := 'create table ';
    tn varchar2(50);
begin
    for i in 1 .. 10 loop
        begin
            tn := t_names(trunc(dbms_random.value(1, t_names.last + 1)))||'_'||i;
            execute immediate sql_q||tn||attrs;
            dbms_output.put_line('테이블 '||tn||' 생성 됨');
        exception
            when others then
                dbms_output.put_line('테이블 '||tn||' 이미 있음');
        end;
    end loop;
end;