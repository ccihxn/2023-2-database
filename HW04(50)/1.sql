DECLARE
    sName starsin.starName%TYPE := '&starName';
    cnt INTEGER;
    average FLOAT;
    star_exist INTEGER;
BEGIN
    sName := LOWER(sName);
    SELECT COUNT(name) INTO star_exist
    FROM movieStar
    WHERE LOWER(name) = sName;
    SELECT COUNT(movieTitle) INTO cnt
    FROM starsin
    WHERE LOWER(starName) = sName;
    SELECT AVG(length) INTO average
    FROM movie, starsin
    WHERE title = movieTitle and year = movieYear and LOWER (starName) = sName;
    IF star_exist = 1 THEN
        IF cnt IS NULL OR average IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('�⿬�� ��ȭ�� �����ϴ�.');
        ELSE
            DBMS_OUTPUT.PUT_LINE(sName || ': �⿬ ��ȭ���[' || cnt || '��], �⿬ ��ȭ�� ��� �󿵽ð�[' || average || '��]');
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('��ġ�ϴ� ��찡 �����ϴ�.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('��ġ�ϴ� ��찡 �����ϴ�.');
END;
