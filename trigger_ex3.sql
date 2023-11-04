create or replace TRIGGER before_movieexec
before update on movieexec
--for each row
declare
    this_year integer := extract(year from sysdate);
begin
    if this_year  = 2023 then
        raise_application_error(-20001, '2023년도에는 MovieExec 튜플삽입 금지');
    end if;
end;