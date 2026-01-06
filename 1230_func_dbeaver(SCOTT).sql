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

-- Number Function
-- round(값, 소수자리 수) => 반올림
-- ex. round(1234.5678, 1) => 소수점 첫번째 자리까지만 출력 => 출력결과: 1234.6. / 위치는 생략가능하며, 생략 시 0으로 취급. 음수로 표현하면 정수 영역의 반올림.
SELECT round(12.455,1) AS "round(1)", round(12.455, 2) "round(2)", round(12.455,3) "round(3)", round(round(round(12.455, 2), 1), 0) "round(2~0)"
FROM dual;

-- trunc(round와 동일) => 버림
SELECT trunc(12.455,1)
FROM dual;

-- mod(값, 나눌값) => 나머지
-- mod(a, b) => a를 b로 나눴을 때 나머지
SELECT MOD(13, 5)
FROM dual;

-- ceil(연산) => 올림
-- ex. ceil(16/5) => 16/5는 3.2가 나오는데 올림을 하면 4가 된다.
SELECT ceil(16/5) 
FROM dual;

-- floor(연산) => 버림
-- ex. floor(13/5) => 13/5는 2.6이 나오는데 버림을 하면 2가 된다.
SELECT floor(13/5)
FROM dual;

-- power(a, b) => 제곱
-- ex. power(3, 2) => 3의 2승으로 3을 2번 '곱'한다.
SELECT power(3,3)
FROM dual;

SELECT birthday, birthday + 1 AS birthday
FROM student;

-- sysdate => 현재 날짜
SELECT sysdate
FROM dual;

-- MONTHS_BETWEEN() => 두 시간 사이의 달 차이
-- MONTHS_BETWEEN(a, b) => a와 b 는 몇달차이 나는지를 출력
SELECT round(MONTHS_BETWEEN(sysdate, birthday)) AS "round(monthsBetween)"
FROM student;

-- add_months(날짜, 더할 개월) => 해당 날짜에서 입력한 개월 뒤의 날짜를 출력.
-- ex. add_month(sysdate, 4) => 지금부터 4개월 뒤의 날짜 출력
SELECT add_months(sysdate, 1) AS addMonths
FROM dual;

-- next_day(날짜, 요일) => 해당 날짜 이후의 가장 가까운 요일의 날짜 출력
-- ex. next_day(sysdate, '월') => 다음 월요일을 출력. 요일의 자리에는 1~7까지 값을 입력해도 된다.(1~7은 순서대로 일요일부터 토요일)
SELECT next_day(sysdate, '목')
FROM dual;

-- last_day(시간) => 해당 날짜의 데이터를 받아와 그 달의 마지막 날짜를 출력
-- ex. last_day(sysdate) => 이번달의 마지막 날짜를 출력.
SELECT last_day(sysdate)
FROM dual;

SELECT round(sysdate - (3/24), 'hh'),
	   trunc(sysdate, 'mm')
FROM dual;

SELECT *
FROM professor
WHERE hiredate < sysdate;

UPDATE professor SET hiredate = add_months(hiredate, -5*12)
WHERE hiredate > sysdate;

SELECT profno, name, pay, bonus, trunc(months_between(sysdate, hiredate)/12) || '년' AS "HIREYEAR"
FROM professor
WHERE months_between(sysdate, HIREDATE) / 12 >= 20;

SELECT 
	profno, 
	name, 
	pay, 
	bonus, 
	trunc(months_between(sysdate, hiredate)/12) || 
	'년 ' || 
	trunc(mod(months_between(sysdate, hiredate), 12)) || 
	'개월' AS "HIRE"
FROM professor
WHERE months_between(sysdate, HIREDATE) / 12 BETWEEN 10 AND 20
ORDER BY hiredate desc;

SELECT 2 + to_number('2') AS "명시적 형변환",
	   2 + '2' AS "묵시적 형변환"
FROM dual;

SELECT sysdate as "SYSDATE", -- date값
               to_char(sysdate, 'YYYY"년" MM"월" DD"일" am hh:mi:ss') AS "SYSDATE_char", -- char값
               to_char(123456789.123456789, '000,000,000.000000000') AS "NUMBER_char", -- char값
               to_date('2025-05-05 070707', 'YYYY-MM-DD hh:mi:ss') AS "DATE"
FROM dual
--where sysdate > sysdate + 1
;

SELECT ename
	   , sal + nvl(comm, 0) AS 총급여
	   , sal + nvl2(comm,comm,0) AS "전체급여"
	   , nvl2(comm, sal + comm, sal) AS "토탈급여"
FROM emp;

SELECT decode('a', 'b', '같다', '다르다')
FROM dual;

SELECT *
FROM department;

SELECT deptno1
	, decode(deptno1
		, '101', 'Computer Engineering'
		, '102', 'Multimedia Engineering'
		, '103', 'Software Engineering'
		, 'etc'
	) AS deptno1_dname
FROM student;

