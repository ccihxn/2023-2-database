create or replace trigger starplays_trigger instead of insert or update on starplays for each row
declare
    type address_type is table of moviestar.address%type;
    type gender_type is table of moviestar.gender%type;
    
    city address_type := address_type('서울특별시', '부산광역시', '대전광역시', '울산광역시', '인천광역시');
    gu address_type := address_type('동구', '남구', '북구', '서구', '중구');
    dong address_type := address_type('교동', '반여동', '중동', '대연동' ,'혜화동', '쌍문동');
    
    max_maked_prod movie.producerno%type;
    address moviestar.address%type;
    gender moviestar.gender%type;
    birthdate moviestar.birthdate%type;
    cnt integer;
begin
    select count(*) into cnt from movie where title = :new.title and year = :new.year;
    if cnt = 0 then
        select producerno into max_maked_prod from 
        (select producerno from movie group by producerno having count(*) = 
        (select max(movie_count) from
        (select count(*) as movie_count from movie group by producerno))
        order by dbms_random.value)
        where rownum = 1;
        insert into movie(title, year, producerno) values (:new.title, :new.year, max_maked_prod);
    end if;
    select count(*) into cnt from moviestar where name = :new.name;
    if cnt = 0 then
        address := city(trunc(dbms_random.value(1, city.last + 1)))||' '||gu(trunc(dbms_random.value(1, gu.last + 1)))||' '||dong(trunc(dbms_random.value(1, dong.last + 1)))||' '||trunc(dbms_random.value(1, 200))||'-'||trunc(dbms_random.value(1, 10));
        birthdate := to_date('1970-01-01') + dbms_random.value(1, 52 * 365);
        select gender into gender from (select gender from moviestar where birthdate = (select max(birthdate) from moviestar) order by dbms_random.value) where rownum = 1;
        insert into moviestar values (:new.name, address, gender, birthdate);
    end if;
    insert into starsin values (:new.title, :new.year, :new.name);
end;