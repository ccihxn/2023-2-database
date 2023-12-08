declare
    type stinfo_rec is record(
        name studioinfo.name%type,
        address studioinfo.address%type,
        president studioinfo.president%type
    );
    type studio_type is table of stinfo_rec;
    studio_infos studio_type;
    studio_info stinfo_rec;
    movie_info studioinfo.movies%type;
    star_info studioinfo.stars%type;
    cursor studio_csr is select name, address, president from studioinfo;
    cursor movie_csr(studioname studioinfo.name%type) is select movies from studioinfo where studioname = name;
    cursor star_csr is select stars from studioinfo;
begin
--영화사 이름, 영화사 주소, 영화사 사장,                                                                                                       영화 제목,                      개봉 연도,                      제작 예산,                      제작자,                            소속 배우명,                 계약금액, 계약 기간
    dbms_output.put_line(lpad(rpad('*영화사 이름', 18), 30)||lpad(rpad('*영화사 주소', 47), 62)||lpad(rpad('*영화사 사장', 15), 30));
    open studio_csr;
    loop
        fetch studio_csr into studio_info;
        exit when studio_csr%notfound;
        dbms_output.put_line(rpad(studio_info.name, 30)||rpad(studio_info.address, 60)||studio_info.president);
        dbms_output.put_line(lpad('**제작 영화 정보', 20));
        dbms_output.put_line(rpad(lpad('*영화 제목', 17), 30));
        open movie_csr(studio_info.name);
        loop
            fetch movie_csr into movie_info;
            exit when movie_csr%notfound;
            dbms_output.put_line(lpad(rpad(movie_info.title, 20), 27));
        end loop;
        close movie_csr;
    end loop;
    close studio_csr;
    dbms_output.put_line(lpad(rpad('영화 제목', 15), 30)||lpad(rpad('개봉 연도', 15), 30)||lpad(rpad('제작 예산', 15), 30)||lpad(rpad('제작자', 15), 30)||lpad(rpad('소속 배우명', 15), 30)||lpad(rpad('계약금액', 15), 30)||lpad(rpad('계약 기간', 15), 30));
    
end;