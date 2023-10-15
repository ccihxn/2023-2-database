
declare
    type studio_type is table of studio%rowtype;
    type star_type is table of moviestar%rowtype;
    type starsin_type is table of starsin%rowtype;
    starsin_table starsin_type := starsin_type();
    studio_table studio_type := studio_type();
    star_table star_type := star_type();
    producer_info movieexec%rowtype;
    cursor producer_csr is select distinct movieexec.* from movieexec, movie where certno = producerno order by name asc;
    cursor pres_csr is select distinct movieexec.* from movieexec, studio where certno = presno order by movieexec.name asc;
    cursor studio_csr(producer_cert movieexec.certno%type) is select studio.* from studio, movieexec where producer_cert = presno and certno = presno order by movieexec.name asc;
    cursor star_csr(producer_name movieexec.name%type) is select moviestar.* from starsin, moviestar where producer_name = name and starname = name order by starname asc, movieyear asc;
    cursor movie_csr(producer_name movieexec.name%type) is select starsin.* from starsin, movieexec where producer_name = starname and starname = name order by starname asc, movieyear asc;
    i integer := 1;
    cnt integer;
    star_cnt integer;
    sum_cnt integer := 0;
    sum_star_cnt integer := 0;
    gender char(2);
begin
    open producer_csr;
    loop
        fetch producer_csr into producer_info;
        exit when producer_csr%notfound;
        open studio_csr(producer_info.certno); 
            fetch studio_csr bulk collect into studio_table;
        close studio_csr;
        open star_csr(producer_info.name);
            fetch star_csr bulk collect into star_table;
        close star_csr;
        open movie_csr(producer_info.name);
            fetch movie_csr bulk collect into starsin_table;
        close movie_csr;
        dbms_output.put_line('제작자['||producer_info.name||']: 주소['||producer_info.address||'], 재산['||producer_info.networth||'원]');
        select count(studio.name) into cnt from studio, movieexec where certno = presno and producer_info.certno = presno;
        if cnt = 0 then
            dbms_output.put_line(lpad('운영 영화사: 없음', 19));
        else
            dbms_output.put_line(lpad('운영 영화사: ', 15));
            for i in 1 .. cnt loop
                if i > 1 and studio_table(i).name = studio_table(i - 1).name then
                    dbms_output.put_line(lpad('이름[', 10)||studio_table(i + 1).name||'], 사무실 주소['||studio_table(i + 1).address||']');
                else
                    dbms_output.put_line(lpad('이름[', 10)||studio_table(i).name||'], 사무실 주소['||studio_table(i).address||']');
                end if;
            end loop;
        end if;
        select count(starname) into star_cnt from starsin where producer_info.name = starname;
        if star_cnt = 0 then
            dbms_output.put_line(lpad('배우 경력: 해당 없음.', 23));
            
        else
            if star_table(1).gender = 'male' then gender := '남성';
            else gender := '여성';
            end if;
            dbms_output.put_line(lpad('배우 경력: ', 13)||'성별['||gender||'], 총 영화편수['||star_cnt||'편]');
            dbms_output.put_line(lpad('최초 출연 영화: ', 20)||starsin_table(1).movietitle||'['||starsin_table(1).movieyear||'년]');
            dbms_output.put_line(lpad('최근 출연 영화: ', 20)||starsin_table(star_cnt).movietitle||'['||starsin_table(star_cnt).movieyear||'년]');  
        end if;
        sum_cnt := sum_cnt + cnt;
        sum_star_cnt := sum_star_cnt + star_cnt;
    end loop;
    close producer_csr;
end;