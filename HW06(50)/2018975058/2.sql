declare
    movies_info studioinfo.movies%type;
    stars_info studioinfo.stars%type;
    cursor studio_cursor is select * from studioinfo;
begin
    for studio_info in studio_cursor loop
        movies_info := studio_info.movies;
        dbms_output.put_line(rpad('*영화사 이름', 18)||lpad(rpad('*영화사 주소', 47), 62)||lpad(rpad('*영화사 사장', 15), 30));
        dbms_output.put_line(rpad(studio_info.name, 30)||rpad(studio_info.address, 60)||studio_info.president);
        if movies_info.count > 0 then
            dbms_output.put_line(lpad('**제작 영화 정보', 20));
            dbms_output.put_line(rpad(lpad('*영화 제목(개봉 연도)', 28), 61)||'*제작자 이름');
            for i in movies_info.first .. movies_info.last loop
                dbms_output.put_line(lpad(rpad(movies_info(i).title||'('||movies_info(i).year||')', 50), 57)||movies_info(i).producer);
            end loop;
        else
            dbms_output.put_line(lpad('*제작한 영화가 없습니다.', 28));
        end if;
        dbms_output.new_line();
        stars_info := studio_info.stars;
        if stars_info.count > 0 then
            dbms_output.put_line(lpad('**소속 배우 정보', 20));
            dbms_output.put_line(rpad(lpad('*배우 이름', 17), 40)||rpad('*계약금', 30)||'*계약 기간');
            for i in stars_info.first .. stars_info.last loop
                dbms_output.put_line(lpad(rpad(stars_info(i).name, 31), 38)||rpad(stars_info(i).salary, 29)||stars_info(i).cont_period||'년');
            end loop;
        else
            dbms_output.put_line('*소속된 배우 정보가 없습니다.');
        end if;
        
        dbms_output.new_line();
        dbms_output.new_line();
        dbms_output.new_line();
    end loop;
end;