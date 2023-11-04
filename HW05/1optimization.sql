declare
    pres_info movieexec%rowtype;
    studio_name studio.name%type;
    cursor csr is select distinct movieexec.* from movieexec left join studio on certno = presno, movie where certno = producerno order by movieexec.name asc;
    cursor studio_csr(pres_no movieexec.certno%type) is select name from studio where presno = pres_no order by name desc;
    cnt integer;
    idx integer := 1;
begin
    open csr;
    loop
        fetch csr into pres_info;
        exit when csr%notfound;
        select count(studio.name) into cnt from movieexec left join studio on certno = presno where certno = pres_info.certno;
        if cnt = 0 then
            dbms_output.put_line('['||idx||'] 제작자 '||pres_info.name||'는 영화사를 운영하지 않는다.');
        else
            dbms_output.put('['||idx||'] 제작자 '||pres_info.name||'는 ');
            open studio_csr(pres_info.certno);
                for i in 1 .. cnt-1 loop
                    fetch studio_csr into studio_name;
                    dbms_output.put(studio_name||', ');
                end loop;
                fetch studio_csr into studio_name;
                dbms_output.put_line(studio_name||'을 운영한다.');
            close studio_csr;
        end if;
        idx := idx + 1;
    end loop;
    close csr;
end;