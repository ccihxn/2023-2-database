declare
    type n_ty is table of people.name%type;
    type a_ty is table of varchar2(100);

    names   n_ty := n_ty('정부용','전지환','배수훈');
    city    a_ty := a_ty('부산광역시','서울특별시','울산광역시','대구광역시');
    gu      a_ty := a_ty('해운대구','남구','동구','북구');
    dong    a_ty := a_ty('우동','대연동','반여동','재송동');
    sql_q varchar2(200);
begin
    for i in names.first..names.last loop
            sql_q := 'insert into people values (:1,:2,phone_tab(),addr_tab())';
            execute immediate sql_q using names(i),
                to_date('1950-01-01')+trunc(dbms_random.value(1,70*365));
        for p in 1..dbms_random.value(1,5) loop
            sql_q := 'insert into
                    table(select phone_list from people where name = :1)
                        values (phone_ty(:2,:3,:4))';
                execute immediate sql_q using names(i),'mobile',p,
                    '010-'||trunc(dbms_random.value(1000,10000))||'-'
                        ||trunc(dbms_random.value(1000,10000));
        end loop;
        for a in 1..dbms_random.value(1,5) loop
            sql_q := 'insert into
                    table(select addresses from people where name = :1)
                        values (addr_ty(:2,:3,:4))';
                execute immediate sql_q using names(i),
                    city(trunc(dbms_random.value(1,city.last+1))),
                    gu(trunc(dbms_random.value(1,gu.last+1))),
                    dong(trunc(dbms_random.value(1,dong.last+1)));
        end loop;
    end loop;
end;