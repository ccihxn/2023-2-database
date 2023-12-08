DECLARE
    TYPE std_type IS RECORD (
        st_name studio.name%TYPE,
        st_address studio.address%TYPE,
        st_presname movieexec.name%TYPE,
        st_presaddress movieexec.address%TYPE
    );
    TYPE std IS TABLE OF std_type INDEX BY studio.name%TYPE;
    std_array std;
    i studio.name%TYPE;
    cnt INTEGER := 1;
BEGIN
    for stds in (SELECT s.name st_name, s.address st_address, m.name st_presname, m.address st_presaddress 
                FROM studio s, movieexec m 
                WHERE s.presNo = m.certNo) 
    LOOP
    std_array(stds.st_name) := stds;
    END LOOP;
    i := std_array.FIRST;
    DBMS_OUTPUT.PUT_LINE(RPAD('순번', 15)||RPAD('영화사', 30)|| RPAD('영화사 주소', 60)||RPAD('영화사 사장', 25)||LPAD('사장 주소', 30));
    WHILE i IS NOT NULL LOOP
        DBMS_OUTPUT.PUT_LINE(RPAD('['||cnt||']', 10)||RPAD(std_array(i).st_name, 25)|| RPAD(std_array(i).st_address, 60)||RPAD(std_array(i).st_presname, 40)||RPAD(std_array(i).st_presaddress, 30));
        i := std_array.NEXT(i);
        cnt := cnt + 1;
    END LOOP;
END;
