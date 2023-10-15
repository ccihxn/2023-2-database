declare
    type exec_ty is table of movieexec%rowtype; 
    type studio_ty is table of studio.name%type;
    exec movieexec%rowtype;
    exec_info exec_ty := exec_ty();
    pres_info exec_ty := exec_ty();
    cursor exec_csr is select * from movieexec order by name asc;
    cursor pres_csr is select movieexec.* from movieexec, studio where certno = presno order by movieexec.name asc, studio.name desc;
    cursor studio_csr is select studio.name from movieexec, studio where certno = presno and movieexec.name = (select movieexec.name from movieexec, studio where certno = presno group by movieexec.name having count(presno) > 1);
    studio_name studio.name%type;
    studio_names studio_ty := studio_ty();
    cnt integer;
    is_pres integer := 0;

begin
    open exec_csr;
    loop
        fetch exec_csr into exec;
        exit when exec_csr%notfound;
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
        select count(movieexec.name) into cnt from movieexec left join studio on certno = presno where certno = exec_info(i).certno;
        is_pres := 0;
        for j in pres_info.first .. pres_info.last loop
            if exec_info(i).certno = pres_info(j).certno then
                is_pres := 1;
            end if;
        end loop;
        dbms_output.put_line('i : ' || i);
        dbms_output.put_line('is_pres : ' || is_pres);
        dbms_output.put_line('name : ' || exec_info(i).name);
        dbms_output.put_line('cnt : ' || cnt);
        if is_pres = 1 then
           
            if cnt = 1 then
                select name into studio_name from studio where presno =pres_info(i).certno;
                dbms_output.put_line('['||i||'] 제작자 '||pres_info(i).name||'는 '||studio_name||'을 운영한다.');
            else
                open studio_csr;
                loop
                    exit when studio_csr%notfound;
                    fetch studio_csr into studio_name;
                    studio_names.extend;
                    studio_names(studio_csr%rowcount) := studio_name;
                end loop;
                close studio_csr;
                dbms_output.put('['||(i)||'] 제작자 '||pres_info(i).name||'는 ');
                for j in 1 .. cnt loop
                    if j = cnt then
                        dbms_output.put(studio_names(j));
                    else 
                        dbms_output.put(studio_names(j)||', ');
                    end if;
                end loop;
                dbms_output.put_line('을 운영한다.');
            end if;
        else
            dbms_output.put_line('['||i||'] 제작자 '||pres_info(i).name||'는 영화사를 운영하지 않는다.');
        end if;
    end loop;
end;
        /*if is_pres = 1 then
            if cnt > 1 then
                open studio_csr;
                loop
                    exit when studio_csr%notfound;
                    fetch studio_csr into studio_name;
                    studio_names.extend;
                    studio_names(studio_csr%rowcount) := studio_name;
                end loop;
                close studio_csr;
                dbms_output.put('['||(i)||'] 제작자 '||pres_info(i).name||'는 ');
                for j in 1 .. cnt loop
                    if j = cnt then
                        dbms_output.put(studio_names(j));
                    else 
                        dbms_output.put(studio_names(j)||', ');
                    end if;
                end loop;
                dbms_output.put_line('을 운영한다.');
                exit;
            else
                select name into studio_name from studio where presno =pres_info(i).certno;
                dbms_output.put_line('['||i||'] 제작자 '||pres_info(i).name||'는 '||studio_name||'을 운영한다.');
            end if;
        else
            dbms_output.put_line('['||i||'] 제작자 '||pres_info(i).name||'는 영화사를 운영하지 않는다.');
        end if;
    end loop;
end;*/
        
        
        
        
        
        
        
/*begin
    open exec_csr;
        loop
            fetch exec_csr into exec;
            exit when exec_csr%notfound;
            exec_info.extend;
            exec_info(exec_csr%rowcount) := exec;
        end loop;
    close exec_csr;
    for i in exec_info.first .. exec_info.last loop
        dbms_output.put_line(i||' '||exec_info(i).name);
    end loop;
    open pres_csr;
    loop
        exit when pres_csr%notfound;
        fetch pres_csr into exec;
        pres_info.extend;
        pres_info(pres_csr%rowcount) := exec;
    end loop;
    close pres_csr;
    for i in pres_info.first .. pres_info.last loop
        dbms_output.put_line(i||' '||pres_info(i).name);
    end loop;
end;*/        
/*        if is_pres = 1 then
            if cnt > 1 then
                open studio_csr;
                loop
                    exit when studio_csr%notfound;
                    fetch studio_csr into studio_name;
                    studio_names.extend;
                    studio_names(studio_csr%rowcount) := studio_name;
                end loop;
                close studio_csr;
                dbms_output.put('['||(i)||'] 제작자 '||pres_info(i).name||'는 ');
                for j in 1 .. cnt loop
                    if j = cnt then
                        dbms_output.put(studio_names(j));
                    else 
                        dbms_output.put(studio_names(j)||', ');
                    end if;
                end loop;
                dbms_output.put_line('을 운영한다.');
                exit;
            else
                select name into studio_name from studio where presno =pres_info(i).certno;
                dbms_output.put_line('['||i||'] 제작자 '||pres_info(i).name||'는 '||studio_name||'을 운영한다.');
            end if;
        else
            dbms_output.put_line('['||i||'] 제작자 '||pres_info(i).name||'는 영화사를 운영하지 않는다.');
        end if;
    end loop;
end;

select * from movieexec order by 

