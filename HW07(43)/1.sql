create or replace trigger star_insert before insert or update on moviestar for each row
declare
    type address_type is table of moviestar.address%type;
    type gender_type is table of moviestar.gender%type;
    city address_type := address_type('서울특별시', '부산광역시', '대전광역시', '울산광역시', '인천광역시');
    gu address_type := address_type('동구', '남구', '북구', '서구', '중구');
    dong address_type := address_type('교동', '반여동', '중동', '대연동' ,'혜화동', '쌍문동');
    genders gender_type := gender_type('male', 'female');
    cnt integer;
    m_cnt integer;
    f_cnt integer;
begin
    if :new.name is null then
        :new.name := dbms_random.value(1,100);
    end if;
    if :new.address is null then
        :new.address := city(trunc(dbms_random.value(1, city.last + 1)))||' '||gu(trunc(dbms_random.value(1, gu.last + 1)))||' '||dong(trunc(dbms_random.value(1, dong.last + 1)))||' '||trunc(dbms_random.value(1, 200))||'-'||trunc(dbms_random.value(1, 10));
    end if;
    if :new.birthdate is null then
        :new.birthdate := to_date('1950-01-01') + dbms_random.value(1, 70 * 365);
    end if;
    if :new.gender is null then
        select count(*) into m_cnt from moviestar where gender = 'male' and birthdate >= '1950-01-01' group by gender;
        select count(*) into f_cnt from moviestar where gender = 'female' and birthdate >= '1950-01-01' group by gender;
        if m_cnt > f_cnt then
            :new.gender := 'male';
        elsif f_cnt > m_cnt then
            :new.gender := 'female';
        else
            :new.gender := genders(trunc(dbms_random.value(1, genders.last + 1)));
        end if;
    end if;
end;