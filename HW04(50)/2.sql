CREATE OR REPLACE PROCEDURE get_starinfo(star_name IN movieStar.name%TYPE, cnt OUT INTEGER, average OUT FLOAT)
IS
    star_exist INTEGER;
BEGIN
    SELECT COUNT(name) INTO star_exist
    FROM movieStar
    WHERE LOWER(name) = LOWER(star_name);
    SELECT COUNT(movieTitle) INTO cnt
    FROM starsin
    WHERE LOWER(starName) = LOWER(star_name);
    SELECT AVG(length) INTO average
    FROM movie, starsin
    WHERE title = movieTitle and year = movieYear and LOWER (starName) = LOWER(star_name);
    IF cnt IS NULL OR average IS NULL THEN
        cnt := -1;
        average := -1;
    END IF;
    DBMS_OUTPUT.PUT_LINE(star_name||': 출연 영화편수['||cnt||'편], 출연 영화의 평균 상영시간['||average||'분]');
END;
