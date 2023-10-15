declare
    cursor exec_csr is select distinct movieexec.* from movieexec, movie where certno = producerno order by name asc;
    cursor pres_csr is select distinct movieexec.* from movieexec, studio where certno = presno order by movieexec.name asc;
    cursor studio_csr is select studio.name from movieexec, studio where certno = presno and movieexec.name = (select movieexec.name from movieexec, studio where certno = presno group by movieexec.name having count(presno) > 1) order by studio.name desc;
    exec movieexec%rowtype;
    pres movieexec%rowtype;
    studio_name studio.name%type;
    cnt integer;
    cnt_id integer := 1;
    i integer := 1;
begin
    open exec_csr;
    open pres_csr;
    loop
        fetch exec_csr into exec;
        exit when exec_csr%notfound;
        fetch pres_csr into pres;
        select count(presno) into cnt from movieexec left join studio on certno = presno where certno = exec.certno group by movieexec.name order by movieexec.name asc;
        if cnt > 1 then
            open studio_csr;
            dbms_output.put('['||cnt_id||'] 제작자 '||exec.name||'는 ');
            loop
                exit when studio_csr%notfound;
                fetch studio_csr into studio_name;
                if i = cnt then
                    dbms_output.put(studio_name); 
                elsif i < cnt then
                    dbms_output.put(studio_name||', ');
                end if;
                i := i + 1;
            end loop;
            close studio_csr;
            dbms_output.put_line('을 운영한다.');
            exit;
        elsif cnt = 1 then
            select name into studio_name from studio where presno = exec.certno;
            dbms_output.put_line('['||cnt_id||'] 제작자 '||exec.name||'는 '||studio_name||'을 운영한다.');
        else
            dbms_output.put_line('['||cnt_id||'] 제작자 '||exec.name||'는 영화사를 운영하지 않는다.');
        end if;
        cnt_id := cnt_id + 1;
    end loop;
    close exec_csr;
    close pres_csr;
end;