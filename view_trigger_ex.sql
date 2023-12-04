create or replace trigger fox_trigger instead of insert on fox_movies for each row
declare

begin
    if updating then
        update fox_movies
        set studioname = 'fox'
        where title = :new.title and year = :new.year;
    else
        insert into movie(title, year, studioname) values (:new.title, :new.year, 'fox');
    end if;
    
end;