declare
    type n_ty is varray(5) of integer;
    nums n_ty := n_ty(10, 0, 30);
    range_over exception;
    pragma exception_init(range_over, -6532);
begin
    nums.extend(3);
    for i in nums.first .. nums.last loop
        begin
            dbms_output.put_line(i * 10||'/'||nums(i)||' = '||i * 10 / nums(i));
        exception
            when zero_divide then
                dbms_output.put_line('0으로 나눔...');
            when others then
                dbms_output.put_line(SQLCODE||' = '||SQLERRM);
        end;
    end loop;
exception
    when range_over then
        dbms_output.put_line('첨자값 범위 오류...');
end;