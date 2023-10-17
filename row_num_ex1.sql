select * from (select m.*, rownum r from (select * from movie order by length desc) m)
where r = 5;

select * from movie order by dbms_random.value;

select trunc(dbms_random.value(1, 10)) from dual;
/* 1 <= index < 10 */

select dbms_random.string('U', 5) from dual;
/*Uppper*/

select dbms_random.string('L', 5) from dual;
/*Lower*/

select dbms_random.string('X', 5) from dual;

select '010-'||trunc(dbms_random.value(1000, 10000))||'-'||trunc(dbms_random.value(1000, 10000)) from dual;
/*Phone_num rand*/

select to_date('1950-01-01', 'YYYY-MM-DD') + trunc(dbms_random.value(1, 365 * 50)) from dual;
/*1950-01-01부터 50년 간의 random date 생성*/

select table_name from user_tables;
/*user가 가지고 있는 table 정보들을 긁어옴.*/

desc user_tables;
