create or replace function GetMovies(name movieexec.name%type)
return integer
is
    cnt integer;
    prod_name movieexec.name%type;
begin
    prod_name := name;
    select count(producerno) into cnt from movieexec left join movie on certno = producerno where name = prod_name;
    return cnt;
exception
    when others then
        return 0;
end;