-- 255p 문제 4번
SELECT *
FROM customer;

SELECT *
FROM gift;

SELECT c.gname AS cust_name, c.point, g.gname AS gift_name
FROM customer c
JOIN gift g ON c.point >= g.g_start AND g.gname = 'Notebook'
;


-- create table => 테이블 생성
-- 게시판 테이블(게시글번호, 제목, 내용, 작성자, 작성시간, 조회수)
CREATE TABLE board (
	b_no NUMBER PRIMARY KEY,			-- 게시글 번호
	b_title varchar2(40) NOT NULL,		-- 게시글 제목
	b_contnent varchar2(1000) NOT NULL,	-- 게시글 본문 / 컬럼명 오타 시X
	b_writer varchar2(30) NOT NULL,		-- 게시글 작성자
	b_regdate DATE DEFAULT sysdate,		-- 게시글 작성일
	b_count NUMBER DEFAULT 0			-- 게시글 조회수
);

-- ALTER TABLE OOO RENAME COLUMN (before)column_name to (after)column_name => 컬럼 수정
ALTER TABLE board 
RENAME COLUMN b_contnent 
TO b_content;

-- INSERT INTO TABLE OOO VALUES ~ => 데이터 삽입
INSERT INTO board(b_no, b_title, b_content, b_writer) 
VALUES(4, '신규회원관리', '신규 회원 아이디는 50글자 미만으로 작성해주세요.', 'admin');

-- ALTER TABLE OOO ADD (column_name datatype); => 컬럼 추가
ALTER TABLE board 
ADD (dududu NUMBER);

-- ALTER TABLE OOO DROP COLUMN (column_name); => 컬럼 삭제
ALTER TABLE board 
DROP COLUMN dududu;

-- ALTER TABLE OOO MODIFY column datatype; => 컬럼 수정
ALTER TABLE board 
MODIFY b_writer varchar2(30);

-- 한번에 여러개 수정
ALTER TABLE board 
MODIFY (b_regdate DATE DEFAULT sysdate NOT NULL, b_count NUMBER DEFAULT 0 NOT NULL);

-- 테이블 삭제 (데이터도 전부 날라간다)
DROP TABLE board;

SELECT * 
FROM board;

--COMMIT : 영구저장
--ROLLBACK : 커밋 이후의 변경사항을 취소하는 거. => 가장 최근의 커밋으로 돌아간다.
COMMIT;
ROLLBACK;

SELECT column_name, data_type, data_length, nullable
FROM user_tab_columns
WHERE table_name = 'PRODUCT';

-- CRUD
--C: CREATE
--R: READ
--U: UPDATE
--D: DELETE

SELECT *
FROM dept2;

INSERT INTO dept2 VALUES (9001, 'temp2', 1006, 'Temp Area');

SELECT *
FROM product;

-- 여러 테이블에 데이터 삽입
-- insert all
--  	into table_nameA values (a,b,c,d ...)
--  	into table_nameB values (a,b,c,d ...)
-- select *
-- from dual
INSERT ALL 
	INTO product 
	VALUES (777, 'Potato Chip', 1200)
	INTO product 
	VALUES (888, 'Potato', 1500)
SELECT *
FROM dual;

-- CTAS : CREATE TABLE AS
CREATE TABLE professor2
	AS
		SELECT * FROM professor;

SELECT * FROM professor2;

DELETE FROM professor2; -- professor2 테이블에서 데이터만 삭제. 용량은 줄어들지 않음.
TRUNCATE TABLE professor2; -- professor2 테이블의 데이터 삭제 후 공간 반환 => 용량이 줄어듬.

-- ITAS : INSERT INTO AS
INSERT INTO professor2
SELECT * 
FROM professor; -- porfessor2 테이블에 professor 테이블의 모든 데이터를 삽입하라는 뜻

-- UPDATE table_name SET 컬럼명 = 변경내용 WHERE 컬럼 = 값
-- WHERE을 안쓰면 테이블의 모든 데이터가 바뀐다.(대참사;;) 그러니까 무조건 WHERE절을 써서 조건을 명확하게 지정해주자.
UPDATE professor2 
SET pay = pay + 100, bonus = bonus + 100 
WHERE profno = 1001;

-- DELETE FROM table_name WHERE 컬럼 = 값
-- UPDATE랑 똑같이 WHERE절을 써서 조건을 명확하게 지정해주자. 안그러면 똑같이 대참사난다.
DELETE FROM professor2 
WHERE profno = 1001;

SELECT *
FROM board;

INSERT INTO board 
VALUES(5, '게시글 연습입니다', '신규글 등록합니다', 'user01', sysdate, 0);

UPDATE board 
SET b_title = '게시글 수정입니다', b_content = '신규글 수정합니다', b_regdate = sysdate 
WHERE b_no = 5;

DELETE FROM board WHERE b_no = 5;

CREATE TABLE student2
AS
SELECT * FROM student;
-- 참고로 위의 내용을 두단계로 나눠서 쓰자면 다음과 같다.
CREATE TABLE student2
AS
SELECT *
FROM student
WHERE 1=2; -- 컬럼의 이름과 데이터 타입 등 데이터를 제외한 테이블의 형태만 student2에 넣는다.

INSERT INTO student2
SELECT *
FROM student; -- student 테이블의 모든 데이터를 student2에 삽입한다.

SELECT * F
ROM student2;
SELECT * 
FROM professor2;

UPDATE student2 
SET profno = (
				SELECT profno 
				FROM professor2 
				WHERE name = 'Jodie Foster')
WHERE name = 'Anthony Hopkins';

SELECT * 
FROM student2
WHERE name = 'Anthony Hokins'

SELECT * 
FROM student2
WHERE grade = 3;

UPDATE student2 
SET deptno2 = ( SELECT deptno 
				FROM department 
				WHERE dname = 'Computer Engineering')
WHERE deptno2 IS NULL AND grade = 3;