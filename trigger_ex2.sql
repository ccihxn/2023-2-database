create or replace TRIGGER after_movie
after insert or delete or update on movie
for each row
declare
begin
    if inserting then
        insert into dml_history values ('Insertion', systimestamp, 'Movie', null, null, :new.title||:new.year);
    elsif deleting then
            insert into dml_history values ('Deletion', systimestamp, 'Movie', null, :old.title||:old.year, null);
    else
        if updating('length') then
            insert into dml_history values ('Update', systimestamp, 'Movie', 'Length', :old.length, :new.length);
        elsif updating('studioname') then
            insert into dml_history values ('Update', systimestamp, 'Movie', 'StudioName', :old.studioname, :new.studioname);
        end if;
    end if;
end;