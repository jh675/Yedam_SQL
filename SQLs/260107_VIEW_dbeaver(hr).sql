-- 뷰(VIEW)
-- 뷰의 목적은 select용으로 복잡한 데이터를 간략하게 보기 위한 것.
-- 뷰는 권한을 따로 줘야된다.
-- 뷰 권한부여(관리자 권한필요) : GRANT create view to 사용자계정

-- simple view
--CREATE OR REPLACE VIEW employees_v
--AS
--SELECT employee_id, first_name, last_name, email, phone_number, hire_date
--FROM employees;

-- complex view
CREATE OR REPLACE VIEW employees_v
AS 
SELECT e.employee_id, e.first_name, e.last_name, e.email, e.phone_number, e.hire_date,
		j.job_title, d.department_name
FROM employees e
JOIN jobs j
ON e.job_id = j.job_id
JOIN departments d
ON e.department_id = d.department_id;

SELECT *
FROM employees;

SELECT *
FROM employees_v;

SELECT *
FROM tab;

-- inline view
SELECT e.DEPARTMENT_ID, d.department_name, max_salary
FROM (SELECT department_id, max(salary) AS max_salary
	  FROM employees
	  GROUP BY department_id) e
JOIN departments d
ON e.DEPARTMENT_ID = d.DEPARTMENT_ID;

