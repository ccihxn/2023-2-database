-- 생성자 Oracle SQL Developer Data Modeler 23.1.0.087.0806
--   위치:        2023-09-22 14:26:28 KST
--   사이트:      Oracle Database 12c
--   유형:      Oracle Database 12c



DROP VIEW Dept_Info CASCADE CONSTRAINTS 
;

DROP VIEW Prof_of_CS CASCADE CONSTRAINTS 
;

DROP VIEW special_lectures CASCADE CONSTRAINTS 
;

DROP TABLE assistant CASCADE CONSTRAINTS;

DROP TABLE class CASCADE CONSTRAINTS;

DROP TABLE class_time CASCADE CONSTRAINTS;

DROP TABLE class_time_of_room CASCADE CONSTRAINTS;

DROP TABLE department CASCADE CONSTRAINTS;

DROP TABLE head_professor CASCADE CONSTRAINTS;

DROP TABLE lecture_room CASCADE CONSTRAINTS;

DROP TABLE parted_class CASCADE CONSTRAINTS;

DROP TABLE professor CASCADE CONSTRAINTS;

DROP TABLE students CASCADE CONSTRAINTS;

DROP TABLE sugang_of CASCADE CONSTRAINTS;

CREATE OR REPLACE TYPE class_date AS OBJECT (
        day        CHAR(1),
        start_time NUMBER(2),
        end_time   NUMBER(2)
) NOT FINAL;
/

CREATE OR REPLACE TYPE phonenum AS OBJECT (
        handphone_no   NUMBER(11),
        homephone_no   NUMBER(11),
        officephone_no NUMBER(11)
) FINAL;
/

CREATE OR REPLACE TYPE people_info AS OBJECT (
        name    VARCHAR2(50),
        address VARCHAR2(255),
        phoneno phonenum
) NOT FINAL;
/

-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE assistant (
    assistant_no   NUMBER(20) NOT NULL,
    assistant_info people_info NOT NULL,
    department     VARCHAR2(50) NOT NULL,
    CHECK ( assistant_info.name IS NOT NULL ),
    CHECK ( assistant_info.phoneno.handphone_no IS NOT NULL )
);

ALTER TABLE assistant
    ADD CHECK ( assistant_info.phoneno.handphone_no BETWEEN 010000000 AND 01099999999 );

ALTER TABLE assistant
    ADD CHECK ( assistant_info.phoneno.homephone_no BETWEEN 010000000 AND 01099999999 );

ALTER TABLE assistant
    ADD CHECK ( assistant_info.phoneno.officephone_no BETWEEN 010000000 AND 01099999999 );

ALTER TABLE assistant ADD CONSTRAINT assistant_pk PRIMARY KEY ( assistant_no );

CREATE TABLE class (
    name              VARCHAR2(50) NOT NULL,
    assistantno       NUMBER(20) NOT NULL,
    number_of_lecture NUMBER(2) NOT NULL
);

ALTER TABLE class ADD CONSTRAINT class_pk PRIMARY KEY ( name );

CREATE TABLE class_time (
    id         NUMBER(20) NOT NULL,
    class_date class_date NOT NULL,
    class_id   NUMBER(20) NOT NULL,
    CHECK ( class_date.day IS NOT NULL ),
    CHECK ( class_date.start_time IS NOT NULL ),
    CHECK ( class_date.end_time IS NOT NULL )
);

ALTER TABLE class_time ADD CONSTRAINT class_time_pk PRIMARY KEY ( id,
                                                                  class_id );

CREATE TABLE class_time_of_room (
    room_id       NUMBER(20) NOT NULL,
    class_time_id NUMBER(20) NOT NULL,
    class_id      NUMBER(20) NOT NULL
);

ALTER TABLE class_time_of_room
    ADD CONSTRAINT class_time_of_room_pk PRIMARY KEY ( room_id,
                                                       class_time_id,
                                                       class_id );

CREATE TABLE department (
    name VARCHAR2(50) NOT NULL
);

ALTER TABLE department ADD CONSTRAINT department_pk PRIMARY KEY ( name );

CREATE TABLE head_professor (
    head_no    NUMBER(20) NOT NULL,
    department VARCHAR2(50) NOT NULL
);

CREATE UNIQUE INDEX head_professor__idx ON
    head_professor (
        head_no
    ASC );

CREATE UNIQUE INDEX head_professor__idxv1 ON
    head_professor (
        department
    ASC );

ALTER TABLE head_professor ADD CONSTRAINT head_professor_pk PRIMARY KEY ( department,
                                                                          head_no );

CREATE TABLE lecture_room (
    id            NUMBER(20) NOT NULL,
    building_name VARCHAR2(50) NOT NULL,
    room_no       NUMBER(4) NOT NULL,
    floor         NUMBER(4),
    capasity      NUMBER(4)
);

ALTER TABLE lecture_room ADD CONSTRAINT lecture_room_pk PRIMARY KEY ( id );

CREATE TABLE parted_class (
    id           NUMBER(20) NOT NULL,
    class_name   VARCHAR2(50) NOT NULL,
    professor_no NUMBER(20) NOT NULL,
    room_id      NUMBER(20) NOT NULL
);

ALTER TABLE parted_class ADD CONSTRAINT parted_class_pk PRIMARY KEY ( id );

CREATE TABLE professor (
    sno            NUMBER(20) NOT NULL,
    professor_info people_info NOT NULL,
    address_office VARCHAR2(255),
    department     VARCHAR2(50),
    CHECK ( professor_info.name IS NOT NULL ),
    CHECK ( professor_info.phoneno.handphone_no IS NOT NULL )
);

ALTER TABLE professor
    ADD CHECK ( professor_info.phoneno.handphone_no BETWEEN 010000000 AND 01099999999 );

ALTER TABLE professor
    ADD CHECK ( professor_info.phoneno.homephone_no BETWEEN 010000000 AND 01099999999 );

ALTER TABLE professor
    ADD CHECK ( professor_info.phoneno.officephone_no BETWEEN 010000000 AND 01099999999 );

ALTER TABLE professor ADD CONSTRAINT professor_pk PRIMARY KEY ( sno );

CREATE TABLE students (
    student_no     NUMBER(20) NOT NULL,
    student_info   people_info NOT NULL,
    degree         VARCHAR2(50),
    department     VARCHAR2(50) NOT NULL,
    sub_department VARCHAR2(50),
    CHECK ( student_info.name IS NOT NULL ),
    CHECK ( student_info.phoneno.handphone_no IS NOT NULL )
);

ALTER TABLE students
    ADD CHECK ( student_info.phoneno.handphone_no BETWEEN 010000000 AND 01099999999 );

ALTER TABLE students
    ADD CHECK ( student_info.phoneno.homephone_no BETWEEN 010000000 AND 01099999999 );

ALTER TABLE students
    ADD CHECK ( student_info.phoneno.officephone_no BETWEEN 010000000 AND 01099999999 );

ALTER TABLE students ADD CONSTRAINT students_pk PRIMARY KEY ( student_no );

CREATE TABLE sugang_of (
    studentno NUMBER(20) NOT NULL,
    class_id  NUMBER(20) NOT NULL
);

ALTER TABLE sugang_of ADD CONSTRAINT sugang_of_pk PRIMARY KEY ( studentno,
                                                                class_id );

ALTER TABLE class
    ADD CONSTRAINT assistant_class_of FOREIGN KEY ( assistantno )
        REFERENCES assistant ( assistant_no );

ALTER TABLE assistant
    ADD CONSTRAINT assistants_major_of FOREIGN KEY ( department )
        REFERENCES department ( name );

ALTER TABLE parted_class
    ADD CONSTRAINT class_of FOREIGN KEY ( room_id )
        REFERENCES lecture_room ( id );

ALTER TABLE class_time_of_room
    ADD CONSTRAINT class_time_of_lecture_room_fk FOREIGN KEY ( room_id )
        REFERENCES lecture_room ( id );

ALTER TABLE class_time_of_room
    ADD CONSTRAINT class_time_of_room_fk FOREIGN KEY ( class_time_id,
                                                       class_id )
        REFERENCES class_time ( id,
                                class_id );

ALTER TABLE parted_class
    ADD CONSTRAINT parted_class_of_professor FOREIGN KEY ( professor_no )
        REFERENCES professor ( sno );

ALTER TABLE professor
    ADD CONSTRAINT professor_of FOREIGN KEY ( department )
        REFERENCES department ( name );

ALTER TABLE parted_class
    ADD CONSTRAINT relation_13 FOREIGN KEY ( class_name )
        REFERENCES class ( name );

ALTER TABLE class_time
    ADD CONSTRAINT relation_14 FOREIGN KEY ( class_id )
        REFERENCES parted_class ( id );

ALTER TABLE head_professor
    ADD CONSTRAINT relation_17 FOREIGN KEY ( head_no )
        REFERENCES professor ( sno );

ALTER TABLE head_professor
    ADD CONSTRAINT relation_18 FOREIGN KEY ( department )
        REFERENCES department ( name );

ALTER TABLE students
    ADD CONSTRAINT students_major_of FOREIGN KEY ( department )
        REFERENCES department ( name );

ALTER TABLE students
    ADD CONSTRAINT sub_major_of FOREIGN KEY ( sub_department )
        REFERENCES department ( name );

ALTER TABLE sugang_of
    ADD CONSTRAINT sugang_of_parted_class_fk FOREIGN KEY ( class_id )
        REFERENCES parted_class ( id );

ALTER TABLE sugang_of
    ADD CONSTRAINT sugang_of_students_fk FOREIGN KEY ( studentno )
        REFERENCES students ( student_no );

CREATE OR REPLACE VIEW Dept_Info ( department, "Count_sno", "Count_assistant_no" ) AS
SELECT
    professor.department,
    COUNT(professor.sno)          AS "Count_sno",
    COUNT(assistant.assistant_no) AS "Count_assistant_no"
FROM
         professor
    INNER JOIN department ON department.name = professor.department
    INNER JOIN assistant ON department.name = assistant.department
GROUP BY
    professor.department
HAVING
    COUNT(professor.sno) >= 2 
;

CREATE OR REPLACE VIEW Prof_of_CS ( name, address_office, "Count_id" ) AS
SELECT
    professor.professor_info.name AS "name",
    professor.address_office,
    COUNT(parted_class.id)        AS "Count_id"
FROM
    professor
    LEFT JOIN parted_class ON professor.sno = parted_class.professor_no
WHERE
    professor.department = '소프트웨어학과'
GROUP BY
    professor.professor_info.name,
    professor.address_office,
    professor.department 
;

CREATE OR REPLACE VIEW special_lectures ( class_name, building_name, room_no, day, start_time, end_time ) AS
SELECT
    parted_class.class_name,
    lecture_room.building_name,
    lecture_room.room_no,
    class_time.class_date.day        AS "day",
    class_time.class_date.start_time AS "start_time",
    class_time.class_date.end_time   AS "end_time"
FROM
         parted_class
    INNER JOIN class_time ON parted_class.id = class_time.class_id
    INNER JOIN lecture_room ON lecture_room.id = parted_class.room_id
WHERE
    ( class_time.class_date.day = '월'
      AND class_time.class_date.start_time = 6
      AND class_time.class_date.end_time = 9 )
    OR ( class_time.class_date.day = '수'
    	 AND class_time.class_date.start_time = 6
      AND class_time.class_date.end_time = 9 )
    OR ( class_time.class_date.day = '금'
    	 AND class_time.class_date.start_time = 6
      AND class_time.class_date.end_time = 9 ) 
;



-- Oracle SQL Developer Data Modeler 요약 보고서: 
-- 
-- CREATE TABLE                            11
-- CREATE INDEX                             2
-- ALTER TABLE                             35
-- CREATE VIEW                              3
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   3
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- TSDP POLICY                              0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
