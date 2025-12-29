SELECT * 
FROM tab;

SELECT *
FROM employees
;

SELECT *
FROM departments;

SELECT *
FROM job_grades;

SELECT *
FROM  jobs;

SELECT *
FROM employees
WHERE  
--salary + salary*nvl(commission_pct, 0) > 10000
department_id IN (20, 80)
;

SELECT e.employee_id "사번", e.first_name "성", e.last_name "이름", e.phone_number "연락처", e.hire_date "입사일", j.job_title "직업", e.salary "급여", e.commission_pct "인센티브", e2.first_name || ' ' || e2.last_name "상사명", d.department_name "부서명"
FROM employees e
LEFT JOIN employees e2
          ON e.manager_id = e2.employee_id
JOIN departments d
    ON e.department_id = d.department_id
JOIN jobs j
    ON e.job_id = j.job_id
;

SELECT *
FROM employees
WHERE department_id = (SELECT department_id
                                            FROM departments
                                            WHERE department_name = 'Shipping')
;

SELECT *
FROM employees
;

--교재 40페이지 연습문제 3번 (과제 겸 복습)
SELECT first_name || '''s sal is $' || salary as "Name And Sal"
FROM employees;