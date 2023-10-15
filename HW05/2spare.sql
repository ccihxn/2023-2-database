declare
	type st_ty is table of starsin%rowtype;
	title starsin%rowtype;
	titles st_ty := st_ty();
	star starsin%rowtype;
	star_info st_ty := st_ty();
	cursor csr is select * from starsin order by starname asc, movieyear asc;
	cursor title_csr is select * from starsin where starname in (select distinct starname from starsin group by starname having count(movietitle) > 1) order by starname asc, movieyear asc;
	cnt integer;
    cnt_id integer := 1;

begin
	open csr;
    open name;
	loop
		exit when csr%notfound;
		fetch csr into star;
		star_info.extend;
        star_info(csr%rowcount) := star;
	end loop;
	close csr;
	for i in star_info.first .. star_info.last loop
        select count(movietitle) into cnt from starsin where starsin.starname = star_info(i).starname group by starname;
        if i > 1 and star_info(i).starname = star_info(i - 1).starname then
            dbms_output.put('');
        else
            if cnt = 1 then
                dbms_output.put_line('['||cnt_id||'] '||star_info(i).starname||' : '||star_info(i).movietitle||'('||star_info(i).movieyear||'년)'||cnt||'편 출연');
                cnt_id := cnt_id + 1;
            elsif cnt > 1 then
                dbms_output.put('['||cnt_id||'] '||star_info(i).starname||' : ');
                cnt_id := cnt_id + 1;
                for j in 1 .. cnt loop
                    open title_csr;
                    loop
                        exit when title_csr%notfound;
                        fetch title_csr into title;
                        titles.extend;
                        titles(title_csr%rowcount) := title;
                    end loop;
                    close title_csr;
                    if j = cnt then
                        dbms_output.put_line(titles(j).movietitle||'('||titles(j).movieyear||'년) '||'등의 '||cnt||'편에 출연');
                    else
                         dbms_output.put(titles(j).movietitle||'('||titles(j).movieyear||'년), ');
                    end if;
                end loop;
            end if;
        end if;
	end loop;
exception
    when no_data_found then
        dbms_output.put('');
end;