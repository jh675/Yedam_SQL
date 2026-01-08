SELECT *
FROM board;

INSERT INTO board VALUES(6, 'test', '', 'user01', sysdate, 0);

ALTER TABLE board
MODIFY b_content varchar2(1000) NOT NULL;

COMMIT;

-- 제약조건 잡아주기
-- CONSTRAINT key_name 
CREATE TABLE dumEmp (
    -- 컬럼명 및 데이터 타입
    eno    NUMBER(4),
    enm    VARCHAR2(50),
    job    VARCHAR2(30),
    mgr    NUMBER,
    jumin  CHAR(14),
    sal    NUMBER,
    comm   NUMBER,
    deptno NUMBER,
    -- 제약조건
    CONSTRAINT PK_eno PRIMARY KEY (eno), -- PRIMARY KEY
    CONSTRAINT CHK_NN_enm CHECK (enm IS NOT NULL), -- NOT NULL
    CONSTRAINT CHK_NN_job CHECK (job IS NOT NULL), -- NOT NULL
    CONSTRAINT CHK_UNI_jumin UNIQUE (jumin), -- UNIQUE KEY
    CONSTRAINT FK_dept_deptno FOREIGN KEY (deptno) REFERENCES dept(deptno) -- FOREIGN KEY
);

SELECT * FROM dumEmp;

INSERT INTO dept
VALUES (50, 'SAMPLE', 'SAMPLE AREA');

INSERT INTO dumEmp
VALUES (1000, 'JinHwan', 'sample', NULL, '000000-0000000', 0, 0, 50);
