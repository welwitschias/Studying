--Q01 departments 테이블에 있는 manager_id 와 employees 테이블의 employee_id를 이용하여
--    조인하여 부서명, 매니저번호, 매니저이름, 전화번호를 나타내어라.
SELECT d.department_name, d.manager_id, e.last_name||' '||e.first_name "FULL_NAME", e.phone_number
FROM departments d
JOIN employees e ON d.manager_id = e.employee_id;


--Q02 조인을 이용하여 사원들의 직원번호, 고용일자, 직종, 직책)을 출력하시오.
SELECT e.employee_id, e.hire_date, j.job_id, j.job_title
FROM employees e
JOIN jobs j ON e.job_id = j.job_id;


--Q03 직책이 'Sales Manager'인 사원들의 입사년도 그룹 별 평균 급여를 출력하시오.
--   (입사년도를 기준으로 오름차순 정렬)
SELECT TO_CHAR(e.hire_date, 'YYYY'), ROUND(AVG(e.salary))
FROM employees e
JOIN jobs j ON e.job_id = j.job_id
WHERE j.job_title = 'Sales Manager'
GROUP BY TO_CHAR(e.hire_date, 'YYYY')
ORDER BY TO_CHAR(e.hire_date, 'YYYY');


--Q04 각각의 도시에 있는 모든 부서 직원들의 평균급여를 조회하고자 한다. 
--    평균급여가 가장 낮은 도시부터 도시명과 평균연봉, 해당 도시의 직원수를 출력하시오.
--    단, 도시에 근무하는 직원이 10명 이상인 곳은 제외하고 조회하시오.
SELECT l.city, ROUND(AVG(e.salary)), COUNT(*)
FROM departments d
JOIN locations l ON d.location_id = l.location_id
JOIN employees e ON d.department_id = e.department_id
GROUP BY l.city
HAVING COUNT(*) < 10
ORDER BY AVG(e.salary);


--Q05 자신의 매니저보다 급여를 많이 받는 직원들의 성, 급여와 매니저의 성, 급여를 출력하라.
SELECT e.employee_id, e.last_name, e.salary, m.last_name, m.salary
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id
WHERE e.salary > m.salary;


--Q01 부서별 직원수
SELECT d.department_name, COUNT(*)
FROM employees e
JOIN departments d ON d.department_id = e.department_id
GROUP BY d.department_name
ORDER BY COUNT(*) DESC;


--Q02 부서별 평균 급여
SELECT d.department_name, ROUND(AVG(e.salary), -1) AVG_SAL
FROM employees e
JOIN departments d ON d.department_id = e.department_id
GROUP BY d.department_name
ORDER BY AVG_SAL DESC;


--Q03 직책별 평균 급여(평균 급여 기준 상위 7개 직책만)
SELECT A.*
FROM (SELECT j.job_title, ROUND(AVG(e.salary)) AVG_SAL
      FROM employees e
      JOIN jobs j ON j.job_id = e.job_id
      GROUP BY j.job_title
      ORDER BY AVG_SAL DESC) A
WHERE ROWNUM <= 7;


--Q04 자신의 매니저보다 더 많은 급여를 받는 사람 목록
SELECT e.employee_id, e.last_name, e.salary
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id
WHERE e.salary > m.salary;


--Q05 Job Title이 Sales Representative인 직원 중에서
--   급여가 9,000 ~ 10,000인 직원들의 이름과 급여를 출력하시오.
SELECT first_name||' '||last_name full_name, e.salary
FROM employees e
JOIN jobs j ON j.job_id = e.job_id
WHERE j.job_title = 'Sales Representative' AND e.salary BETWEEN 9000 AND 10000
ORDER BY e.salary DESC;


--Q06 급여 총합이 가장 높은 직급순으로 급여 총합을 출력하시오.
--   (단, 급여 총합이 30,000 이상인 직급만 출력할 것)
SELECT j.job_title, SUM(e.salary) TOTAL
FROM employees e
JOIN jobs j ON j.job_id = e.job_id
GROUP BY j.job_title
HAVING SUM(e.salary) >= 30000
ORDER BY TOTAL DESC;


--Q07 각 도시별 평균 급여가 높은 순으로 상위 3개 도시를 출력하시오.
SELECT A.*
FROM (SELECT l.city, ROUND(AVG(e.salary)) AVG_SAL
      FROM employees e
      JOIN departments d ON d.department_id = e.department_id
      JOIN locations l ON l.location_id = d.location_id
      GROUP BY l.city
      ORDER BY AVG_SAL DESC) A
WHERE ROWNUM <=3;


--Q08 직책(Job Title)이 'Sales Manager'인 사원들의 입사년도별 평균 급여를 출력하시오.
--    출력시 년도를 기준으로 오름차순 정렬하시오.
SELECT TO_CHAR(e.hire_date, 'YYYY'), ROUND(AVG(e.salary))
FROM employees e
JOIN jobs j ON j.job_id = e.job_id
WHERE j.job_title = 'Sales Manager'
GROUP BY TO_CHAR(e.hire_date, 'YYYY')
ORDER BY TO_CHAR(e.hire_date, 'YYYY');


--Q09 각 도시에 있는 모든 부서 직원들의 평균급여를 조회하고자 한다. 
--    평균급여가 가장 낮은 도시부터 도시명과 평균연봉, 해당 도시의 직원수를 출력하시오. 
--    (단, 도시에 근무하는 직원이 10명 이상인 곳은 제외하고 조회하시오.)
SELECT l.city, ROUND(AVG(e.salary)) AVG_SAL, COUNT(*)
FROM employees e
JOIN departments d ON d.department_id = e.department_id
JOIN locations l ON l.location_id = d.location_id
GROUP BY l.city
HAVING COUNT(*) < 10
ORDER BY AVG_SAL;


--Q10 ‘Public Accountant’의 직책(job_title)으로 과거에 근무한 적이 있는 모든 사원의 사번과 이름을 출력하시오. 
--    (현재 ‘Public Accountant’의 직책으로 근무하는 사원은 고려하지 않는다)
SELECT e.employee_id, e.last_name
FROM jobs j
JOIN job_history jh ON jh.job_id = j.job_id
JOIN employees e ON e.employee_id = jh.employee_id
WHERE j.job_title = 'Public Accountant' AND e.job_id != j.job_id;


--Q11 2007년에 입사한 직원들의 사번, 이름, 성, 부서명을 조회합니다.  
--    이 때 부서에 배치되지 않은 직원의 경우, <Not Assigned>로 출력하시오.
SELECT e.employee_id, e.first_name, e.last_name, NVL(d.department_name, '<Not Assigned>')
FROM employees e
LEFT OUTER JOIN departments d ON d.department_id = e.department_id
WHERE hire_date BETWEEN '2007/01/01' AND '2007/12/31'
ORDER BY e.employee_id;


--Q12 부서별로 가장 적은 급여를 받고 있는 직원의 성(last_name), 부서이름, 급여를 출력하시오. 
--    부서이름으로 오름차순 정렬하고, 부서가 같은 경우 이름을 기준으로 오름차순 정렬하여 출력합니다.
-- 부서별로 최저급여 받는 모든 사람 표시
SELECT e.last_name, A.*
FROM employees e, (SELECT d.department_name, MIN(e.salary) MIN_SAL
                   FROM employees e
                   JOIN departments d ON d.department_id = e.department_id
                   GROUP BY d.department_name) A
WHERE e.salary = A.MIN_SAL
ORDER BY A.department_name, e.last_name;

-- 부서별로 최저급여 받는 1명만 표시
SELECT e.last_name, d.department_name, e.salary
FROM employees e
JOIN departments d ON d.department_id = e.department_id
WHERE (d.department_ID, e.salary) IN (SELECT department_id, MIN(salary)
                                      FROM employees
                                      GROUP BY department_id)
ORDER BY d.department_name, e.last_name;


--Q13 EMPLOYEES 테이블에서 급여를 많이 받는 순서대로 조회했을 때 6번째부터 10번째까지 직원의
--    last_name, first_name, salary를 조회하는 SQL문장을 작성하시오.
SELECT B.last_name, B.first_name, B.salary
FROM (SELECT ROWNUM RN, A.*
    FROM (SELECT * FROM employees ORDER BY salary DESC) A)B -- A:정렬, B:순서
WHERE RN BETWEEN 6 AND 10;


--Q14 ‘Sales’ 부서에 속한 직원의 이름(first_name), 급여, 부서이름을 조회하시오. 
--    (단, 급여는 100번 부서의 평균보다 적게 받는 직원 정보만 출력되어야 한다.)
SELECT e.first_name, e.salary, d.department_name
FROM employees e
LEFT OUTER JOIN departments d ON d.department_id = e.department_id
WHERE d.department_name = 'Sales'
AND e.salary < (SELECT ROUND(AVG(salary)) FROM employees WHERE department_id = 100);


--Q15 부서별 입사월별 직원수를 출력하시오. 
--    단, 직원수가 5명 이상인 부서만 출력되어야 하며 출력결과는 부서이름순으로 한다.
SELECT d.department_name, TO_CHAR(e.hire_date, 'MM'), COUNT(*)
FROM employees e
JOIN departments d ON d.department_id = e.department_id
GROUP BY d.department_name, TO_CHAR(e.hire_date, 'MM')
HAVING COUNT(*) >= 5
ORDER BY d.department_name;


--Q16 커미션을 가장 많이 받은 상위 4명의 부서명, 직원명(first_name), 급여, 커미션 정보를 조회하시오. 
--    커미션을 많이 받는 순서로 출력하되 동일한 커미션에 대해서는 급여가 높은 직원이 먼저 출력되게 한다.
SELECT A.*
FROM (SELECT d.department_name, e.first_name, e.salary, e.commission_pct
      FROM employees e
      JOIN departments d ON d.department_id = e.department_id
      WHERE e.commission_pct IS NOT NULL
      ORDER BY e.commission_pct DESC, e.salary DESC) A
WHERE ROWNUM <= 4;