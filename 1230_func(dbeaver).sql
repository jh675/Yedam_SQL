SELECT empno, ename, sal, nvl(comm,0) AS commission
FROM emp;

SELECT initcap(POSITION) AS "initcap", -- 첫 글자만 대문자로
	   upper(POSITION) AS "upper", -- 전체 대문자
	   lower(POSITION) AS "lower", -- 전체 소문자
	   upper(lower(POSITION)) AS "lower -> upper", -- 전체를 소문자 한 후 대문자로 변경
	   LENGTH(POSITION) AS "length", -- 문자의 크기 반환
	   lengthb('김진환') AS "lengthb(KR)", -- byte 크기 반환(한글)
	   lengthb('KIMJINHWAN') AS "lengthb(EN)", -- byte  크기 반환(영어)
	   POSITION,
	   name
FROM professor
WHERE LENGTH(name) < 10;

SELECT *
FROM emp;

SELECT ename || job AS ename_and_job, -- 연결연산자
	   concat(ename, job) AS ename_and_job -- 연결연산자 함수
FROM emp;

SELECT ename || ', ' || job AS ename_and_job,
	   concat(ename, concat (', ', job)) AS ename_and_job
FROM emp;

SELECT e.ename || ', ' || e.job AS ename_and_job,
	   concat(e.ename, concat (', ', e.job)) AS ename_and_job,
	   substr(e.job, 1, 3) AS short_job
FROM emp e;

SELECT substr('abcde', 3), -- 문자를 잘라내서 출력. substr(자를려는 데이터, 시작 위치, 크기(생략하면 끝까지))
	   substr('hello, Database', -8) -- 시작위치는 마이너스도 가능. 마이너스의 경우에는 뒤에서부터 시작.
FROM dual;

SELECT ename
FROM emp
WHERE substr(ename, 1, 1) = 'J';

SELECT *
FROM student;

SELECT tel, instr(tel, ')', 1) "location OF ')'"
FROM STUDENT
WHERE deptno1 = 201;

SELECT name, substr(tel, 1, instr(tel, ')')-1) AS "area code",
	   substr(tel, instr(tel, ')')+1, instr(tel, '-') - instr(tel,')')-1) "tel_s"
FROM student
WHERE deptno1 = 201
AND substr(tel, 1, instr(tel, ')')-1) = '02';

SELECT instr(tel, '-') - instr(tel,')')-1
FROM STUDENT;

SELECT lpad('abc', 10, '*') AS lpad -- LPAD(컬럼, 자릿수, 채울문자)
FROM dual;

SELECT *
FROM STUDENT
WHERE DEPTNO1 = 201;

SELECT studno, name, lpad(id, 10, '*') AS id, grade, jumin, birthday, tel, height, weight, deptno1, deptno2, profno
FROM student
WHERE deptno1 = 201;

SELECT LPAD(ename, 9, 123456789) lpad,
	   rpad(ename, 9, '-') rpad
FROM emp
WHERE deptno = 10;

SELECT rpad(ename, 9, substr(123456789, LENGTH(ename)+1)) rpad
FROM EMP
WHERE deptno = 10
ORDER BY 1
;

-- trim(문자 혹은 컬럼, 잘라낼 문자)
-- 참고로 사이에있는 문자는 안된다.
SELECT ltrim('abcdefg', 'abc') ltrim,
	   rtrim('abcdefg', 'efg') rtrim,
	   rtrim(ltrim('    hello    ', ' '), ' ') "ltrim -> rtrim" -- ltrim 후 rtrim 적용 => 좌우 제거
FROM dual;

-- replace(문자 혹은 컬럼, 대체하고싶은 문자, 대신 넣을 문자)
-- ex. replace('abcde', 'a', 'b') => abcde라는 문자열에서 문자 a를 b로 대체하겠다. => 출력결과 : bbcde
SELECT REPLACE('  hello  ', ' ', '')
FROM dual;

SELECT REPLACE(e.ENAME, substr(e.ename, 1, 2), '*')
	   , REPLACE(e.ename, substr(e.ename, 2, 2), '--')
FROM emp e
WHERE deptno = 10;

-- 84페이지 replace 예제 2번
SELECT name, jumin, REPLACE(jumin, substr(jumin, 7), '-/-/-/-') AS "REPLACE"
FROM student
WHERE deptno1 = 101;

-- 85페이지 replace 예제 3번
SELECT name, 
tel, 
REPLACE(tel, 
	substr(tel, 
		instr(tel, ')')+1, 
		instr(tel, '-') - instr(tel,')')-1), 
		'***') AS "REPLACE"
FROM STUDENT
WHERE deptno1 = 102;

SELECT substr(tel, instr(tel, ')')+1, instr(tel, '-') - instr(tel, ')')-1)
FROM student;

-- 응용
SELECT 
	tel, 
	REPLACE(
		tel, 
		substr(tel, instr(tel, ')')+1, instr(tel, '-') - instr(tel, ')') - 1), 
		RPAD('*', instr(tel, '-') - INSTR(tel, ')') - 1, '*')) AS replace
FROM STUDENT
WHERE deptno1 = 201;

SELECT rpad(tel, 20, '*')
FROM student;

SELECT RPAD('*', instr(tel, '-') - INSTR(tel, ')') - 1, '*')
FROM STUDENT;


-- 85페이지 replace 예제 4번
SELECT name, tel, REPLACE(tel, substr(tel, instr(tel, '-')+1), '****') AS "REPLACE"
FROM student
WHERE deptno1 = 101;