declare
    type exec_type is table of movieexec%rowtype;
    type studio_type is table of studio.name%type;
    exec movieexec%rowtype;
    exec_info exec_type := exec_type();
    pres_info exec_type := exec_type();
    cursor exec_csr is select movieexec.* from movieexec, movie where certno = producerno order by name asc;
    cursor pres_csr is select movieexec.* from movieexec, studio where certno = presno order by movieexec.name asc;
    cursor studio_csr is select studio.name from movieexec, studio where certno = presno and movieexec.name = (select movieexec.name from movieexec, studio where certno = presno group by movieexec.name having count(presno) > 1) order by studio.name desc;
    studio_name studio.name%type;
    studio_names studio_type := studio_type();
    cnt integer;
    cnt_id integer := 1;
begin
    open exec_csr;
    loop            
        exit when exec_csr%notfound;
        fetch exec_csr into exec;
        exec_info.extend;
        exec_info(exec_csr%rowcount) := exec;
    end loop;
    close exec_csr;
    open pres_csr;
    loop
        exit when pres_csr%notfound;
        fetch pres_csr into exec;
        pres_info.extend;
        pres_info(pres_csr%rowcount) := exec;
    end loop;
    close pres_csr;
    for i in exec_info.first .. exec_info.last loop
        if i > 1 and exec_info(i).name = exec_info(i - 1).name then
            dbms_output.put('');
        else
            select count(presno) into cnt from movieexec left join studio on certno = presno where certno = exec_info(i).certno group by movieexec.name order by movieexec.name asc;
            if cnt > 1 then
                open studio_csr;
                loop
                    exit when studio_csr%notfound;
                    fetch studio_csr into studio_name;
                    studio_names.extend;
                    studio_names(studio_csr%rowcount) := studio_name;
                end loop;
                close studio_csr;
                dbms_output.put('['||cnt_id||'] 제작자 '||exec_info(i).name||'는 ');
                for j in 1 .. cnt loop
                    if j = cnt then
                        dbms_output.put(studio_names(j));
                    else 
                        dbms_output.put(studio_names(j)||', ');
                    end if;
                end loop;
                dbms_output.put_line('을 운영한다.');
                exit;
            elsif cnt = 1 then
                select name into studio_name from studio where presno =exec_info(i).certno;
                dbms_output.put_line('['||cnt_id||'] 제작자 '||exec_info(i).name||'는 '||studio_name||'을 운영한다.');
            else 
                dbms_output.put_line('['||cnt_id||'] 제작자 '||exec_info(i).name||'는 영화사를 운영하지 않는다.');
            end if;
            cnt_id := cnt_id + 1;
        end if;
    end loop;
end;