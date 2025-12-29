SELECT * FROM tab;

SELECT s.name as "이름", s.grade as  "학년" , s.tel as "연락처", d.dname as "주전공"
FROM student s JOIN department d 
ON s.deptno1 = d.deptno;
 
SELECT DISTINCT  '부서번호는 ' || deptno  || ', 이름은 ' || ename AS deptno_ename
FROM EMP
ORDER BY 1;

SELECT *
FROM DEPT; -- 부서정보

SELECT * 
FROM student;

SELECT *
FROM DEPARTMENT;

SELECT name || '''s ID: ' || id || ', WEIGHT is ' || weight || 'kg' AS "ID AND WEIGHT"
FROM student;

SELECT *
FROM emp;

SELECT ename || '(' || job || '), ' || ename || '''' || job || '''' AS "NAME AND JOB"
FROM emp;