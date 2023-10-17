declare
    type csr_ty is ref cursor;
    csr csr_ty;
    sql_s varchar2(200) := 'select * from movie 
                            where title = :1 ';
    m movie%rowtype;
begin
    if mod(trunc(dbms_random.value(1, 100)), 2) = 0 then
        sql_s := sql_s || ' and year = :2';
        execute immediate sql_s into m using 'star wars', 1977;
        dbms_output.put_line(m.title||'('||m.year||')');
    else
        open csr for sql_s using 'star wars';
        loop
            fetch csr into m;
            exit when csr%notfound;
            dbms_output.put_line(m.title||'('||m.year||')');
        end loop;
        close csr;
    end if;
end;