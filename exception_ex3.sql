declare
    fox exception;
    mgm exception;
    disney exception;
begin
    for m in (select * from movie) loop
--        dbms_output.put_line(m.title);
--        if m.title like '%and%' then
--          raise_application_error(-20001, '타이틀에 and가 포함되어 있어용!!');
--        end if;
        begin
            dbms_output.put_line(m.title);
            case m.studioname
            when 'fox' then
                raise fox;
            when 'mgm' then
                raise mgm;
            when 'disney' then
                raise disney;
            end case;
        exception
            when case_not_found then
                dbms_output.put_line('기타 영화사 제작');
            when fox then
                dbms_output.put_line('FOX 영화사 제작');
            when mgm then
                dbms_output.put_line('MGM 영화사 제작');
            when disney then
                dbms_output.put_line('DISNEY 영화사 제작');
        end;
    end loop;
end;