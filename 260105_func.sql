SELECT *
FROM tab;

SELECT *
FROM student;

SELECT name
	, jumin
	, decode(substr(jumin, 7, 1), 1, 'MAN', 2, 'WOMAN') as "Gender"
FROM student
WHERE deptno1 = 101;

SELECT name, tel, decode(substr(tel, 1, instr(tel, ')')-1) -- 판별할 값
	, '02', 'seoul', '031', 'gyeonggi', '051', 'busan'
	, '052', 'ulsan', '053', 'daegu', '055', 'gyeongnam') AS "location"
FROM student
--WHERE deptno1 = 101
;

-- CASE ~ WHEN 문
-- CASE(컬럼) WHEN 조건 THEN 조건이 참일 때 실행 내용을 넣는다. WHEN THEN은 여러번 쓸 수 있으며, 콤마(,)가 필요없다.
SELECT name, tel, CASE(substr(tel, 1, instr(tel, ')')-1)) 
	WHEN '02' THEN 'SEOUL'
	WHEN '031' THEN 'GYEONGGI'
	WHEN '051' THEN 'BUSAN'
	WHEN '052' THEN 'ULSAN'
	WHEN '055' THEN 'GYEONGNAM'
	ELSE 'ETC' END AS "location"
FROM student
WHERE deptno1 = 101
;

SELECT name, jumin, CASE(substr(jumin, 7, 1))
	WHEN '1' THEN 'MAN'
	WHEN '2' THEN 'WOMAN'
	ELSE '넌 뭐냐..?' END AS "gender"
FROM student
WHERE deptno1 = 101
;

-- CASE ~ WHEN 문 조건의 범위를 지정
SELECT name, substr(jumin, 3, 2) AS "mon", 
	CASE WHEN substr(jumin, 3, 2) BETWEEN '01' AND '03' THEN '1분기'
		 WHEN substr(jumin, 3, 2) BETWEEN '04' AND '06' THEN '2분기'
		 WHEN substr(jumin, 3, 2) BETWEEN '07' AND '09' THEN '3분기'
		 WHEN substr(jumin, 3, 2) BETWEEN '10' AND '12' THEN '4분기'
		 END AS "quarter"
FROM student
ORDER BY 2
;

--123p CASE문 퀴즈
SELECT empno, ename, sal, 
	CASE WHEN sal BETWEEN 1 AND 1000 THEN 'LEVEL 1'
		 WHEN sal BETWEEN 1001 AND 2000 THEN 'LEVEL 2'
		 WHEN sal BETWEEN 2001 AND 3000 THEN 'LEVEL 3'
		 WHEN sal BETWEEN 3001 AND 4000 THEN 'LEVEL 4'
		 ELSE 'LEVEL 5' END "level"
FROM EMP
;

-- case문 퀴즈 2
SELECT empno, ename, sal, 
	CASE WHEN sal <= 1000 THEN 'LEVEL 1'
		 WHEN sal <= 2000 THEN 'LEVEL 2'
		 WHEN sal <= 3000 THEN 'LEVEL 3'
		 WHEN sal <= 4000 THEN 'LEVEL 4'
		 ELSE 'LEVEL 5' END "level"
FROM emp
;

-- GROUP절
-- GROUP BY 
SELECT DEPTNO AS "부서번호"
	, count(*) AS "인원수"
	, sum(sal + nvl(comm, 0)) AS "부서별 합계 급여"
	, round(avg(sal + nvl(comm, 0))) AS "부서별 평균 급여"
	, max(sal + nvl(comm, 0)) AS "부서별 최고 급여"
	, min(sal + nvl(comm, 0)) AS "부서별 최저 급여"
FROM emp
GROUP BY deptno
;

SELECT job AS "직무", deptno AS "부서번호"
	, count(*) AS "인원수"
	, sum(sal + nvl(comm, 0)) AS "직무별 합계 급여"
	, round(avg(sal + nvl(comm, 0))) AS "직무별 평균 급여"
	, max(sal + nvl(comm, 0)) AS "직무별 최고 급여"
	, min(sal + nvl(comm, 0)) AS "직무별 최저 급여"
	, stddev(sal) AS "표준편차"
	, variance(sal) AS "분산"
FROM emp
GROUP BY job, deptno;

SELECT job
	 , sum(sal + nvl(comm, 0)) AS "직무별 합계 급여"
	 , round(avg(sal + nvl(comm, 0))) AS "직무별 평균 급여"
FROM emp
GROUP BY job
HAVING round(avg(sal + nvl(comm, 0))) > 1500 -- HAVING절은 GROUP절의 조건문이다. WHERE의 GROUP절 버전.
UNION ALL
SELECT '전체', sum(sal), round(avg(sal + nvl(comm, 0)))
FROM emp
;

-- 부서 / 직무 / 정보조회(평균급여, 사원수 etc...)
-- 1. 부서별 직무별 평균급여, 사원수
SELECT deptno||'' AS DEPTNO, job, sum(sal + nvl(comm, 0)) AS "SUM_SAL", round(avg(sal + nvl(comm, 0))) AS "AVG_SAL", count(*) AS "CNT_EMP"
FROM emp
GROUP BY deptno, job
-- union all
UNION ALL
-- 2. 부서별 평균급여, 사원수
SELECT deptno||'', '소계', sum(sal + nvl(comm, 0)), round(avg(sal + nvl(comm, 0))), count(*)
FROM emp
GROUP BY deptno
-- union all
UNION ALL
-- 3. 전체 평균급여, 사원수
SELECT '', '', sum(sal + nvl(comm, 0)), round(avg(sal + nvl(comm, 0))), count(*)
FROM emp
ORDER BY 1, 2
;


-- ROLLUP
SELECT nvl(deptno||'', '전체') AS DEPTNO
	 , CASE WHEN deptno IS NULL THEN nvl(job, '') 
	   ELSE nvl(job, '소계') END AS "JOB"
	 , sum(sal + nvl(comm, 0)) AS "SUM_SAL"
	 , round(avg(sal + nvl(comm, 0))) AS "AVG_SAL"
	 , count(*) AS "CNT_EMP"
FROM emp
GROUP BY ROLLUP(deptno, job)
ORDER BY 1, 2;

-- JOIN
-- emp / dept 테이블
SELECT *
FROM emp;

SELECT *
FROM dept;

SELECT e1.empno AS "사번", e1.ename AS "사원명", e1.job AS "직무", e2.ename AS "상사", e1.hiredate AS "입사일", e1.sal AS "급여", e1.comm AS "인센티브", d.dname AS "부서명"
FROM emp e1
LEFT JOIN emp e2 ON e1.mgr = e2.empno
LEFT JOIN dept d ON d.deptno = e1.deptno
WHERE 
--	e1.ename = 'KING'
	d.dname = 'ACCOUNTING' -- ANSI JOIN
;

SELECT *
FROM student;

SELECT *
FROM professor;

SELECT *
FROM department;

SELECT s.studno AS "학번", s.name AS "성명", s.id AS "계정", s.grade AS "학년", s.jumin AS "주민번호", s.birthday AS "생년월일", s.tel AS "연락처", d.dname AS "주전공", sd.dname AS "부전공", p.name AS "담당교수"
FROM student s
LEFT JOIN professor p ON s.profno = p.profno
LEFT JOIN department d ON d.deptno = s.deptno1
LEFT JOIN department sd ON sd.deptno = s.deptno2
ORDER BY 1;

SELECT s.studno AS "학번", s.name AS "성명", p.name AS "담당교수", d.dname AS "학과명", sd.dname AS "(부)학과명"
FROM student s
LEFT JOIN professor p ON s.profno = p.profno
LEFT JOIN department d ON d.deptno = s.deptno1
LEFT JOIN department sd ON sd.deptno = s.deptno2
ORDER BY 1;

SELECT column_name
FROM user_tab_columns
WHERE table_name = 'STUDENT';

SELECT * 
FROM customer;
SELECT *
FROM gift;

SELECT c.*, g.gname
FROM CUSTOMER c
--JOIN GIFT g ON c.POINT BETWEEN g.g_start AND g.g_end
JOIN GIFT g ON c.point >= g.G_START AND c.POINT <= g.G_END;
;

SELECT s.studno, s.name, c.total
FROM student s
JOIN score c ON s.STUDNO = c.STUDNO;

SELECT * FROM score;

SELECT *
FROM HAKJUM;

SELECT s.studno, s.name, c.total, h.grade
FROM student s
JOIN score c ON s.STUDNO = c.STUDNO
JOIN hakjum h ON c.total BETWEEN h.MIN_POINT AND h.MAX_POINT;

-- 254p 문제 1번
-- ANSI JOIN
SELECT s.name, s.deptno1, d.dname
FROM STUDENT s
JOIN DEPARTMENT d ON s.deptno1 = d.deptno;

-- Oracle JOIN
SELECT s.name, s.deptno1, d.dname
FROM STUDENT s, DEPARTMENT d 
WHERE s.DEPTNO1 = d.DEPTNO;

-- 254p 문제 2번
SELECT e.name, p.POSITION, e.pay, p.s_pay AS "Low Pay", p.e_pay AS "High Pay"
FROM emp2 e
JOIN P_GRADE p ON e.POSITION = p.POSITION;

-- 255p 문제 3번
SELECT e.name, trunc(months_between(sysdate, e.birthday) / 12) AS "AGE", nvl(e.POSITION, ' ') AS "CURR_POSITION", pg.POSITION AS "BE_POSITION"
FROM emp2 e
JOIN P_GRADE pg ON trunc(months_between(sysdate, e.birthday) / 12) BETWEEN pg.S_AGE AND pg.E_AGE 
;

--- OUTER JOIN(LEFT, RIGHT, FULL)
-- LEFT OUTER JOIN => LEFT JOIN
-- RIGHT OUTER JOIN => RIGHT JOIN
-- FULL OUTER JOIN => FULL JOIN
-- OUTER은 생략이 가능하다.
SELECT s.*
FROM student s
JOIN professor p ON s.PROFNO = p.PROFNO; -- join은 기본적으로 inner join으로 집합으로 따지면 교집합만 적용한다.

SELECT s.*
FROM student s
LEFT /*OUTER*/ JOIN professor p ON s.PROFNO = p.PROFNO; -- left join. A테이블과 B테이블을 join을 할때 A테이블은 무조건 전부 다 가져온다. 학생테이블이 기준이 된다.

SELECT s.studno, s.name, p.profno, p.name
FROM student s
RIGHT /*OUTER*/ JOIN professor p ON s.PROFNO = p.PROFNO; -- right join. A테이블과 B테이블을 join을 할때 B테이블은 무조건 전부 다 가져온다. 교수테이블이 기준이 된다.

SELECT s.studno, s.name, p.profno, p.name
FROM student s
FULL /*OUTER*/ JOIN professor p ON s.PROFNO = p.PROFNO; -- full join. A테이블과 B테이블을 join을 할때 A와 B테이블 양쪽다 무조건 가져온다. 그냥 합집합.

--- SELF JOIN 
-- 자기자신을 참조하는 것.
SELECT e1.empno AS "사번", e1.ename AS "사원명", e1.job AS "직무", e2.ename AS "관리자명", e1.hiredate AS "입사일", e1.sal AS "급여" 
FROM emp e1
JOIN emp e2 ON e1.MGR = e2.EMPNO ;

SELECT e1.empno AS "사번", e1.ename AS "사원명", e1.job AS "직무", e2.ename AS "관리자명", e1.hiredate AS "입사일", e1.sal AS "급여" 
FROM emp e1
LEFT JOIN emp e2 ON e1.MGR = e2.EMPNO;

-- 255p 문제 5번
SELECT *
FROM professor;

SELECT p1.profno, p1.name, p1.HIREDATE, count(p2.hiredate)
FROM professor p1
LEFT JOIN professor p2 ON p1.HIREDATE > p2.HIREDATE
GROUP BY p1.profno, p1.name, p1.hiredate;

-- 255p 문제 6번
SELECT *
FROM emp;

SELECT empno, ename, hiredate, count(*) OVER (ORDER BY hiredate)-1 AS "count"
FROM emp;

SELECT e1.empno, e1.ename, e1.hiredate, count(e2.hiredate)
FROM emp e1
LEFT JOIN emp e2 ON e1.hiredate > e2.hiredate
GROUP BY e1.empno, e1.ename, e1.hiredate