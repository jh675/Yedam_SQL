SELECT ename, sal "인상전 급여", sal + COMM "총 급여", (sal + comm)*1.1 "인상후 급여"
FROM emp
WHERE sal < 3000 
AND JOB = UPPER('salesman')
ORDER BY 4 DESC;

SELECT *
FROM emp;

--2000보다 큰 사람이거나 세일즈직
SELECT *
FROM emp
WHERE sal > 2000
OR JOB = 'SALESMAN';

SELECT *
FROM emp;

SELECT e1.empno, e1.ename, e1.job, e2.ename "MGR", e1.hiredate, e1.sal, e1.comm, e1.deptno
FROM emp e1 JOIN emp e2
ON e1.mgr = e2.empno;

SELECT *
FROM emp
WHERE sal BETWEEN 2000 AND 3000
--WHERE sal <= 3000
--AND sal > 2000
;


--81년도에 입사한 사람들을 조회 1
SELECT *
FROM emp
WHERE hiredate BETWEEN '81/01/01' AND '81/12/31'
;

--81년도에 입사한 사람들을 조회 2
SELECT *
FROM emp
WHERE SUBSTR(hiredate, 1, 2) = '81'
;

-- IN(a, b, c)
SELECT *
FROM emp
WHERE deptno NOT IN (10, 30)
AND ename IN ('SMITH', 'SCOTT');

--IS NULL / IS NOT NULL : NULL의 여부를 조건으로 가져오기
SELECT *
FROM emp
WHERE comm IS NULL;

--LIKE
SELECT *
FROM emp
WHERE ename LIKE '_A%';

-----------------------------------
SELECT *
FROM professor
WHERE deptno  IN (101, 103)
; 

SELECT *
FROM department
WHERE deptno  IN (101, 103);

SELECT *
FROM professor
WHERE deptno in (101,103)
AND position != 'a full professor'
;

SELECT DISTINCT DEPTNO
FROM professor;

SELECT *
FROM professor
WHERE bonus IS NOT NULL
;

SELECT *
FROM professor
--WHERE pay+bonus  >= 300
--OR BONUS IS NULL AND PAY >= 300
WHERE pay + nvl(bonus, 0) >= 300
;


--SELECT e.name "이름", e.id "아이디", e.grade "학년", e.tel "연락처", e.birthday "생일", d1.dname "주전공", d2.dname "부전공", p.name "교수명"
--FROM student e, department d1, department d2, professor p
--WHERE e.deptno1 = d1.deptno
--AND e.profno = p.profno
--AND e.deptno2 = d2.deptno
--ORDER BY 3, 1;

--교수와 학생 테이블에서 교수(학생)번호와 이름, 학과정보를 가져오고 싶다.
SELECT profno, name, deptno
FROM professor
UNION ALL -- 중복된 값까지 보여준다.
--UNION -- 중복된 값은 제거하고 보여준다.
SELECT studno, name, deptno1
FROM student
ORDER BY 3, 1;

--
SELECT studno, name
FROM student
WHERE deptno1 = 101
INTERSECT
SELECT studno, name
FROM student
WHERE deptno2 = 201
ORDER BY 1;