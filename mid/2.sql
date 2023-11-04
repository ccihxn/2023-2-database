create or replace procedure GetStudios(name in movieexec.name%type, count out integer)
is
    pres_name movieexec.name%type;
begin
    pres_name := name;
    select count(studio.name) into count from movieexec left join studio on certno = presno where movieexec.name = pres_name;
end;