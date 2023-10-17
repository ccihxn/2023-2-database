declare
    p_list people.phone_list%type;
    a_list people.addresses%type;
begin
    for p in (select * from people) loop
        dbms_output.put_line(p.name||'('||p.birthdate||')');
        p_list := p.phone_list;
        for i in p_list.first .. p_list.last loop
            dbms_output.put_line(lpad('- ', 5)||p_list(i).name||', '||p_list(i).no);
        end loop;
        a_list := p.addresses;
        for i in a_list.first .. a_list.last loop
            dbms_output.put_line(lpad('- ', 5)||a_list(i).city||', '||a_list(i).gu);
        end loop;
    end loop;
end;