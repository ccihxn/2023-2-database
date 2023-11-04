declare
    mvs movieexecinfo.movies%type;
    stds movieexecinfo.studios%type;
begin
    for e in (select * from movieexecinfo) loop
        dbms_output.put_line(e.name||'('||e.address||') 재산:'||e.networth);
        mvs := e.movies;
        stds := e.studios;
        dbms_output.put_line(lpad('* ', 4)||'제작영화 편수: '||mvs.count||'편');
        if mvs.count > 0 then    
            for i in mvs.first .. mvs.last loop
                dbms_output.put_line(lpad('- ', 6)||mvs(i).title||'('||mvs(i).year||') 계약날짜:'||mvs(i).contract_date);
            end loop;
        end if;
        dbms_output.put_line(lpad('* ', 4)||'운영 영화사 수: '||stds.count);
        if stds.count > 0 then
            for i in stds.first .. stds.last loop
                dbms_output.put_line(lpad('- ', 6)||stds(i).name||'('||stds(i).emp_count||')');
            end loop;
        end if;
    end loop;
end;