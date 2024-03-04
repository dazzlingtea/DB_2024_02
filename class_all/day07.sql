
/*
 * LEFT OUTER JOIN
 * employees, departments 테이블을 LEFT OUER JOIN을 시킨다
 * employees 테이블을 기준 테이블로 사용한다
 * 조인 조건 : 부서번호가 같은 컬럼끼리 연결한다 
 */

-- 오라클 (+) 반대편이 기준테이블이 된다
SELECT *
FROM employees e, departments d
WHERE e.department_id = d.department_id(+);

-- 안시
SELECT *
FROM employees e LEFT OUTER JOIN departments d
ON e.department_id = d.department_id;

/*
 * RIGHT OUTER JOIN
 * employees, departments 테이블을 RIGHT OUER JOIN을 시킨다
 * departments 테이블을 기준 테이블로 사용한다
 * 조인 조건 : 부서번호가 같은 컬럼끼리 연결한다 
 */

-- 오라클
SELECT *
FROM emplyoees e, departments d
WHERE e.department_id(+) = d.department_id;

-- 안시
SELECT *
FROM employees e RIGHT OUTER JOIN departments d
ON e.department_id = d.department_id;

/*
 * 여러개의 테이블 조인
 * N개의 테이블 조인 -> N-1개의 조인 조건이 필요하다
 */

-- employees(사원), departments(부서), locations(지역)
-- 사원의 근무 도시를 조회하기

-- 오라클
SELECT e.employee_id, l.city
FROM employees e, departments d, locations l
WHERE e.department_id = d.department_id 
AND d.location_id = l.location_id;

-- 안시
-- employees <> departments 테이블 연결 -> 하나의 테이블
-- 위의 테이블과 나머지 테이블(locationos) 연결
SELECT e.employee_id, l.city
FROM employees e INNER JOIN departments d
ON e.department_id = d.department_id INNER JOIN locations l
ON d.location_id = l.location_id;

-- 도시별 부서번호와 해당 부서에 속하는 사원의 수 조회하기
SELECT l.city, d.department_id, count(*)
FROM employees e, departments d, locations l
WHERE e.department_id = d.department_id 
AND d.location_id = l.location_id
GROUP BY l.city, d.department_id
ORDER BY 1;

-- 모든 사원들의 소속된 부서의 부서명을 조회하기
-- employees 테이블의 사원수는 107명

SELECT d.department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id(+);

/*
 * 셀프 조인
 */

-- employees 테이블을 셀프 조인한다
-- e1 : 부하테이블, e2 : 매니저테이블
SELECT e1.employee_id 사번
	,e1.first_name 사원명
	,e2.employee_id 매니저사번
	,e2.first_name 매니저명
FROM employees e1, employees e2
WHERE e1.manager_id = e2.employee_id;

/*
 * 중첩 서브쿼리
 */

-- 단일행 비상관 서브쿼리
-- 단일행 : 서브쿼리 실행결과가 단일행
-- 비상관 : 서브쿼리가 메인쿼리의 컬럼을 가지지 않는다

-- employees 테이블에서 급여가 제일 높은 사원의 정보 조회하기
SELECT *
FROM employees e
WHERE e.salary = (SELECT max(salary) FROM employees);

-- 124번 사원과 부서가 동일한 사원들 조회하기
SELECT *
FROM employees e
WHERE e.department_id = (SELECT department_id 
						FROM employees 
						WHERE employee_id = 124);	

SELECT department_id
FROM employees 
WHERE employee_id = 124;

-- 124번 사원보다 급여가 높은 사원들의 사원번호, 급여 조회하기
SELECT e.employee_id, e.salary
FROM employees e
WHERE e.salary > (SELECT salary 
				FROM employees 
				WHERE employee_id = 124)
ORDER BY 2;

SELECT salary FROM employees 
WHERE employee_id = 124;

-- 평균급여보다 급여가 높은 사원의 사원번호, 급여 조회하기
SELECT e.employee_id, e.salary
FROM employees e
WHERE e.salary > (SELECT avg(salary) FROM employees)
ORDER BY 2;

SELECT avg(salary) FROM employees;

/*
 * 실습. 
 * 부서별로 전체 평균급여보다 급여가 높은 사원의 수 구하기
 */

SELECT department_id, count(*)
FROM employees 
WHERE salary > (SELECT avg(salary) FROM employees)
GROUP BY department_id;


/*
 * 다중행 비상관 서브쿼리
 * 다중행 : 서브쿼리의 결과가 다중행
 * 비상관 : 메인쿼리의 컬럼을 사용하지 않는다
 */

-- salary > 6500, 6700
-- 지역번호가 1700번에 해당하는 부서번호 구하기

SELECT location_id, department_id
FROM departments
WHERE location_id = 1700;

-- 부서의 지역번호가 1700번에 해당하는 사원들 조회하기
-- 사원의 부서번호가 21개의 부서번호 중 하나라도 일치하면 조회한다
SELECT department_id, employee_id
FROM employees
WHERE department_id IN (SELECT department_id 
						FROM departments
						WHERE location_id = 1700);

-- NOT IN
-- 124번 사원과 동일 부서가 아닌 사원들 조회하기
SELECT employee_id, department_id
FROM employees
WHERE department_id NOT IN (SELECT department_id
							FROM departments
							WHERE employee_id = 124);
					
-- 60번 부서의 사원들의 급여 조회하기
-- 4200, 4800, 4800, 6000, 9000
SELECT department_id, salary
FROM employees
WHERE department_id = 60
ORDER BY 2;
						
-- ANY : 여러개 중 1개라도 조건을 만족한다면
-- 급여가 60번 부서 사원들의 급여중 1개보다 크다면 조회			
SELECT salary
FROM employees
WHERE salary > ANY (SELECT salary 
					FROM employees
					WHERE department_id = 60)
ORDER BY 1;

-- 여러개의 값중에 최소값과 비교하는것과 동일
SELECT salary
FROM employees
WHERE salary > (SELECT min(salary) 
				FROM employees
				WHERE department_id = 60);
						
-- ALL : 여러개 값을 모두 만족한다면
-- 급여가 60번 부서 사원들 모두의 급여보다 큰 사원 조회하기
SELECT salary
FROM employees
WHERE salary > all(SELECT salary
					FROM employees
					WHERE department_id = 60);

-- 여러개의 값중 최대값과 비교하는것과 동일
SELECT salary
FROM employees
WHERE salary > (SELECT max(salary) 
				FROM employees
				WHERE department_id = 60);

/*
 * 단일행 상관 쿼리
 * 단일행 : 서브쿼리 결과가 단일행
 * 상관 : 메인쿼리의 컬럼을 서브쿼리가 사용
 */
			
-- 부서 평균급여보다 급여가 높은 사원 조회하기
SELECT avg(salary)
FROM employees
GROUP BY department_id;
			
SELECT e.department_id, e.salary
FROM employees e
WHERE e.salary > (SELECT avg(salary)
					FROM employees
					WHERE department_id = e.department_id);

-- 3475
SELECT avg(salary)
FROM employees
WHERE department_id = 50;

/*
 * 다중행 상관 서브쿼리
 * 다중행 : 서브쿼리 실행결과가 다중행
 * 상관 : 메인쿼리의 컬럼을 서브쿼리가 사용
 */

-- EXISTS : 메인쿼리의 결과가 서브쿼리 조건을 만족하여 존재하면 조회

-- 사원이 존재하는 부서만 조회하기
-- 서브쿼리안에 부서번호를 메인쿼리에서 가져온 부서번호를 대입해서
-- 쿼리를 실행했을때 1개 이상의 결과가 조회되면 메인쿼리의 행을 조회한다
SELECT d.department_id, d.department_name
FROM departments d
WHERE EXISTS (SELECT 1 FROM employees e
				WHERE d.department_id = e.department_id);

SELECT 1
FROM employees
WHERE department_id = 270;

-- 이름이 David인 사원이 속한 부서만 부서명 조회하기
SELECT d.department_name
FROM departments d
WHERE exists(SELECT 1 FROM employees e
			WHERE first_name = 'David'
			AND e.department_id = d.department_id);

SELECT 1 FROM employees e
WHERE first_name = 'David'
AND e.department_id = 10;

-- HAVING절과 서브쿼리
-- 부서의 평균 급여가 전체 급여 평균보다 높은 부서만 조회하기
SELECT department_id, avg(salary)
FROM employees
GROUP BY department_id
HAVING avg(salary) > (SELECT avg(salary) FROM employees);

/*
 * 스칼라 서브쿼리
 */

-- 집계함수와 일반컬럼은 같이 조회할수 없다
SELECT salary, avg(salary)
FROM employees;

SELECT salary, 6500
FROM employees;

SELECT salary, (SELECT avg(salary) FROM employees)
FROM employees;

-- 부서별 평균급여, 전체사원의 평균급여 같이 조회하기
SELECT avg(salary), 6500
FROM employees
GROUP BY department_id;

SELECT avg(salary), (SELECT avg(salary) FROM employees)
FROM employees
GROUP BY department_id;

-- 스칼라 서브쿼리도 상관쿼리로 사용할수 있다
SELECT e.department_id, e.salary
	,(SELECT avg(salary) 
		FROM employees
		WHERE department_id = e.department_id)
FROM employees e;

/*
 * 인라인뷰
 */

-- 부서번호가 60인 사원의 부서번호, 부서명, 급여 조회하기
-- 서브쿼리 실행결과를 하나의 테이블로 사용하게 된다
SELECT d.department_id, d.department_name, e.salary
FROM departments d, (SELECT * FROM employees
					WHERE department_id = 60) e
WHERE d.department_id = e.department_id;

SELECT * FROM employees
WHERE department_id = 60;

SELECT d.department_id, d.department_name, e.salary
FROM departments d, employees e
WHERE d.department_id = e.department_id  
AND e.department_id = 60;

-- 부서명, 부서 최고급여, 최저급여, 사원의 수 조회하기

SELECT department_id, max(salary), min(salary), count(*)
FROM employees
GROUP BY department_id;

SELECT d.department_name, e.*
FROM departments d
,(SELECT department_id, max(salary), min(salary), count(*)
	FROM employees
	GROUP BY department_id) e
WHERE d.department_id = e.department_id;

SELECT *
FROM employees;

-- ROWNUM : 오라클이 조회 대상 행들에게 부여하는 가상의 순번
SELECT rownum, employee_id
FROM employees;

SELECT rownum, employee_id
FROM employees
WHERE rownum = 2;

-- 부서번호가 80번인 사원들 5명만 조회하기
SELECT rownum, employee_id
FROM employees
WHERE department_id = 80 AND rownum <= 5;






