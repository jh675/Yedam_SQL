SELECT /*+ INDEX(e EMP_EMP_ID_PK) */e.rowid, e.*
FROM employees e;

-- employees_id 컬럼의 인덱스테이블에 저장.
SELECT e.rowid, e.*
FROM employees e
ORDER BY e.employee_id;

-- index 만들기
CREATE INDEX emp_hireDate_ix
ON employees(hire_date);