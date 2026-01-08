-- 460p 문제 2번
--학과별 학생들의 최대 키, 몸무게
SELECT d.dname, max_height, max_weight
FROM (SELECT deptno1, max(height) AS max_height, max(weight) AS max_weight
	  FROM student
	  GROUP BY deptno1) s
JOIN department d
ON s.DEPTNO1 = d.deptno;

-- 460p 문제 3번
--학과별 가장 큰 키를 가진 사람의 키와 이름
SELECT d.dname, max_height, s.name, s.height
FROM student s
JOIN (SELECT deptno1, max(height) AS max_height
	  FROM student
	  GROUP BY deptno1) s1
ON s.DEPTNO1 = s1.DEPTNO1 
AND s.height = max_height
JOIN department d
ON s.DEPTNO1 = d.DEPTNO;

--ward 커미션 -> 적은 커미션을 받는 사람들 목록
SELECT *
FROM emp e
WHERE e.comm < (SELECT comm FROM emp WHERE ename = 'WARD');

-- where절 뒤에 오는 서브 쿼리는 sub query(서브 쿼리)라고 함.
-- from절 뒤에 오는 서브 쿼리는 inline view(인라인 뷰)라고 함.

--429p 연습문제 1번
SELECT s.name AS stud_name, d.dname AS dept_name
FROM student s
JOIN department d
ON s.DEPTNO1 = d.DEPTNO
WHERE s.DEPTNO1 = 
	(SELECT deptno1
	 FROM student 
	 WHERE name = 'Anthony Hopkins');

SELECT column_name
FROM user_tab_columns
WHERE table_name = 'DEPARTMENT';

-- 429p 연습문제 2번
SELECT p.name AS prof_name, p.hiredate, d.dname AS dept_name
FROM PROFESSOR p 
JOIN DEPARTMENT d
ON p.DEPTNO = d.DEPTNO
WHERE p.HIREDATE > 
	(SELECT hiredate
	 FROM professor
	 WHERE name = 'Meg Ryan');

-- ?

SELECT *
FROM student;

SELECT name, d1.dname AS mDname, d2.dname AS sDname
FROM student s
JOIN DEPARTMENT d1
ON s.DEPTNO1 = d1.DEPTNO
JOIN DEPARTMENT d2
ON s.DEPTNO2 = d2.DEPTNO
WHERE EXISTS ( SELECT 1
			   FROM student t
			   WHERE t.name = 'James Seo'
			   AND (s.deptno1 IN (t.deptno1, t.deptno2)
			   	OR s.deptno2 IN (t.deptno1, t.deptno2))
			   	)
;

-- 439 ~ 440p 사용예 
SELECT empno, name, deptno
FROM emp2 e
LEFT JOIN dept2 d
ON e.deptno || '' = d.dcode
WHERE d.area = 'Pohang Main Office';

SELECT empno, name, deptno
FROM emp2 e
WHERE e.DEPTNO IN (SELECT dcode FROM dept2 WHERE area = 'Pohang Main Office');

-- 432p Exists 함수
-- sql developer에서만 가능함. dbeaver에서는 불가능. 자바 실행 문제
SELECT *
FROM dept
WHERE EXISTS (SELECT deptno FROM dept WHERE deptno = &dno);

SELECT column_name
FROM user_tab_columns
WHERE table_name = 'EMP2';
SELECT column_name
FROM user_tab_columns
WHERE table_name = 'DEPT2';

-- 434p 연습문제 1
SELECT name, POSITION, to_char(pay, '$9,999,999,999,999') AS salary
FROM EMP2
WHERE pay > (SELECT min(pay) FROM emp2 WHERE POSITION = 'Section head');

SELECT name, POSITION, to_char(pay, '$9,999,999,999,999') AS salary
FROM emp2
WHERE pay > ANY (SELECT pay FROM emp2 WHERE POSITION = 'Section head');

-- 434p 연습문제 2
SELECT name, grade, weight
FROM student
WHERE weight < (SELECT min(weight) FROM student WHERE grade = 2);

SELECT name, grade, weight
FROM student
WHERE weight < ALL (SELECT weight FROM student WHERE grade = 2);

-- 435p 연습문제 3
-- emp2 테이블 조회
SELECT *
FROM emp2;

-- dept2 테이블 조회
SELECT *
FROM dept2;

-- 부서별 평균 연봉
SELECT avg(pay)
FROM emp2
GROUP BY deptno;

-- 부서별 평균 연봉 중에서 가장 연봉이 적은 곳
SELECT min(avg(pay))
FROM emp2
GROUP BY deptno;

-- 평균 연봉이 가장 낮은 부서보다 급여가 적은 직원의 이름과 급여
SELECT name, pay
FROM emp2
WHERE pay < (SELECT min(avg(pay)) FROM emp2 GROUP BY deptno);

-- 평균 연봉이 가장 낮은 부서보다 급여가 적은 직원의 부서 코드와 이름 및 급여 (박봉이누;;)
SELECT deptno, name, pay
FROM emp2
WHERE pay < (SELECT min(avg(pay)) FROM emp2 GROUP BY deptno);

-- 문제 4번 답 드디어 구했다
SELECT d.dname, name, pay
FROM emp2 e
JOIN dept2 d
ON e.DEPTNO = d.DCODE 
WHERE pay < (SELECT min(avg(pay)) FROM emp2 GROUP BY deptno);

-- 한 학생의 주전공과 

-- 436p 연습문제 1번
-- 테이블 조회(professor, department)
SELECT *
FROM professor;

SELECT *
FROM department;

--학과별로 입사일이 가장 오래된 교수의 입사일
SELECT p.profno, p.name, p.hiredate, d.dname AS dept_name
FROM professor p
JOIN department d
ON p.DEPTNO = d.DEPTNO 
WHERE hiredate = ( 
	SELECT min(hiredate)
	FROM professor
	WHERE deptno = p.deptno);