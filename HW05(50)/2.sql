declare
    cursor star_csr is select distinct starname from starsin order by starname asc;
    cursor movie_csr(star starsin.starname%type) is select * from starsin where starname = star order by starname asc, movieyear asc;
    star starsin.starname%type;
    i integer := 1;
    movie_info starsin%rowtype;
    cnt integer;
    j integer;
begin
    open star_csr;
    loop
        fetch star_csr into star;
        exit when star_csr%notfound;
        select count(movietitle) into cnt from starsin where star = starname;
        open movie_csr(star);
        dbms_output.put('['||i||'] '||star||' : ');
        for j in 1.. cnt loop
            exit when movie_csr%notfound;
            fetch movie_csr into movie_info;
            if j = cnt then
                dbms_output.put_line(movie_info.movietitle||'('||movie_info.movieyear||'년) '||'등의 '||cnt||'편에 출연');
            else
                dbms_output.put(movie_info.movietitle||'('||movie_info.movieyear||'년), ');
            end if;
        end loop;
        i := i + 1;
        close movie_csr;
    end loop;
    close star_csr;
end;