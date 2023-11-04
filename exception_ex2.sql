declare
    m movie%rowtype;
    many_tuples exception;
    
    pragma exception_init(many_tuples, -1422);
begin
    insert into movie(title, year) values ('star wars', 1977);
    select * into m from movie where title = 'star wars';
exception
    when many_tuples then
        dbms_output.put_line('데이터가 많아용');
    when others then
        dbms_output.put_line(SQLCODE||' = '||SQLERRM);
end;