declare
    prod_info movieexec%rowtype;
    pres_info movieexec%rowtype;
    studio_name studio.name%type;
    cursor prod_csr is select distinct movieexec.* from movieexec, movie where certno = producerno order by name asc;
    cursor pres_csr is select movieexec.* from movieexec, studio where certno = presno;
    cursor studio_csr is select name from studio where presno = (select presno from movieexec, studio where certno = presno group by certno having count(presno) > 1);
    idx integer := 1;
    cnt integer;
begin
    open prod_csr;
    loop
        fetch prod_csr into prod_info;
        exit when prod_csr%notfound;
        open pres_csr;
            fetch pres_csr into pres_info;
        close pres_csr;
        select count(presno) into cnt from movieexec left join studio on presno = certno where presno = prod_info.certno;
        if cnt > 1 then
            open studio_csr;
                dbms_output.put('['||idx||'] 제작자 '||prod_info.name||'는 ');
                for i in 1 .. cnt - 1 loop
                    fetch studio_csr into studio_name;
                    dbms_output.put(studio_name||', ');
                end loop;
                fetch studio_csr into studio_name;
                dbms_output.put_line(studio_name||'을 운영한다.');
            close studio_csr;
        elsif cnt = 1 then
            select name into studio_name from studio where presno = prod_info.certno;
            dbms_output.put_line('['||idx||'] 제작자 '||prod_info.name||'는 '||studio_name||'을 운영한다.');
        else
            dbms_output.put_line('['||idx||'] 제작자 '||prod_info.name||'는 영화사를 운영하지 않는다.');
        end if;
        idx := idx + 1;
    end loop;
end;