-- CASE문 DECODE 퀴즈 1
SELECT *
FROM student;

SELECT name, jumin, decode(substr(jumin,7,1), 1, 'MAN', 2, 'WOMAN') as "Gender"
FROM student
WHERE deptno1 = 101;

-- CASE DECODE 퀴즈 2
SELECT name, tel, decode(substr(tel, 1, instr(tel, ')')-1), 02, 'SEOUL', 031, 'GYEONGGI', 051, 'BUSAN', 052, 'ULSAN', 055, 'GYEONGNAM') as "LOC"
FROM student
WHERE deptno1 = 101;