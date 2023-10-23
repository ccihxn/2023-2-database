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
            DBMS_OUTPUT.PUT_LINE('출연한 영화가 없습니다.');
        ELSE
            DBMS_OUTPUT.PUT_LINE(sName || ': 출연 영화편수[' || cnt || '편], 출연 영화의 평균 상영시간[' || average || '분]');
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('일치하는 배우가 없습니다.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('일치하는 배우가 없습니다.');
END;
