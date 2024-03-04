-- rownum : 오라클에서 부여하는 가상의 순번

SELECT rownum, employee_id
FROM employees;

SELECT rownum, employee_id
FROM employees
WHERE rownum <= 5;

SELECT rownum, employee_id, department_id
FROM employees
WHERE department_id = 80 AND rownum <= 5;

-- 급여 내림차순으로 정렬하고 급여 순위가 1~5위인 사원만 조회하기
-- 24,000 > 17,000 > 17,000 > 9,000 > 6,000
SELECT rownum, employee_id, salary
FROM employees
WHERE rownum <= 5
ORDER BY salary DESC;

-- 실제로 급여 내림차순으로 데이터를 정렬해서 조회한다
-- 24,000 > 17,000 > 17,000 > 14,000 > 13,500
-- rownum이 order by 보다 먼저 부여되기 때문에
-- 정렬하고 5개를 가져오는게 아닌 5개를 가져오고 정렬이 진행된다
SELECT salary
FROM employees
ORDER BY salary DESC;

-- employees 테이블이 아닌 급여 내림차순으로 정렬된 데이터를 
-- 가상의 테이블로 사용한다(인라인뷰)
SELECT rownum, employee_id, salary
FROM (SELECT * FROM employees ORDER BY salary DESC)
WHERE rownum <= 5;

SELECT rownum, rn, employee_id, salary
FROM (SELECT rownum AS rn, employee_id, salary
	FROM employees
	ORDER BY salary DESC)
WHERE rownum <= 5;

-- 1~5번에 해당하는 사원을 조회한다
SELECT rownum, employee_id
FROM employees
WHERE rownum <= 5;

-- 6~10번에 해당하는 사원을 조회한다
SELECT rownum, employee_id
FROM employees
WHERE rownum BETWEEN 6 AND 10;

-- 11~15번에 해당하는 사원을 조회한다
SELECT rownum, employee_id
FROM employees
WHERE rownum BETWEEN 11 AND 15;

SELECT rownum, employee_id
FROM employees
WHERE rownum = 1;

-- rownum 은 반드시 1부터 시작해야 한다
SELECT rownum, employee_id
FROM employees
WHERE rownum = 2;

-- 6~10번에 해당하는 사원을 조회하기 위해 인라인뷰를 사용한다
SELECT rownum, e.rn, e.employee_id
FROM (SELECT rownum AS rn, employee_id FROM employees) e
WHERE e.rn BETWEEN 6 AND 10;

/*
 * 급여가 높은 순서로 6~10위 사원의 급여 조회하기
 * 1. rownum은 1부터 시작해야 한다
 * 2. rownum은 정렬되기 전에(order by) 부여된다
 */

-- 급여가 높은순으로 정렬
SELECT rownum, salary
FROM employees
ORDER BY salary DESC;

-- 급여 높은순으로 순번을 부여하기 위해 인라인뷰를 사용
SELECT rownum, rn, salary
FROM (SELECT rownum AS rn, salary FROM employees ORDER BY salary DESC);

-- 6~10위에 해당하는 순번을 가져오기 위해 인라인뷰를 사용
SELECT rownum, e2.*
FROM (SELECT rownum AS salary_rank, e1.*
	from(SELECT rownum AS rn, salary FROM employees ORDER BY 2 desc) e1) e2
WHERE e2.salary_rank BETWEEN 6 AND 10;

/*
 * ROWNUM : 정렬 전에 순번을 붙인다
 * ROW_NUMBER() : 정렬 후에 순번을 붙인다
 * RANK() : 중복 순위가 존재하면 다음 순위를 건너띈다(1 -> 2(2명) -> 4)
 * DENSE_RANK() : 중복 순위가 존재해도 다음 순위를 부여한다(1 -> 2(2명) -> 3)
 */

SELECT rownum
	,row_number() over(ORDER BY salary DESC) AS row_fuc
	,rank() over(ORDER BY salary DESC) AS rank_fuc
	,dense_rank() over(ORDER BY salary DESC) AS densc_fuc
	,salary
FROM employees;

-- 급여 내림차순으로 1~5위에 해당하는 사원 조회하기(ROW_NUMBER()함수 사용)
SELECT row_number() over(ORDER BY salary DESC), salary
FROM employees;

CREATE TABLE tbl_user(
	name varchar2(1000) -- 유저 이름
	,age NUMBER			-- 유저 나이
	,birth_date DATE	-- 유저 생년월일
	,point NUMBER		-- 유저 포인트 금액
);

/*
 * INSERT : 데이터 삽입(행을 추가한다)
 */

-- 1. 모든 컬럼에 값을 채워서 삽입한다
-- 유저 이름, 나이, 생년월일, 포인트 금액에 값을 입력해서 행을 추가한다
INSERT INTO tbl_user
values('박철수', 20, '2003-04-06', 30);

SELECT * FROM tbl_user;

-- 모든 컬럼에 값을 채울때는 컬럼의 순서와 자료형에 주의해야 한다
--INSERT INTO tbl_user
--values(21, '나훈아', '2004-09-10', 20);

INSERT INTO tbl_user
values('나훈아', 21, '2004-09-10', 20);

-- 현재날짜와 시간을 사용할때는 sysdate 키워드 사용 가능
INSERT INTO tbl_user
values('김짱구', 21, sysdate, 10);

-- 2. 특정 컬럼에만 값을 채워서 행을 추가한다
INSERT INTO tbl_user(
	name
	,age
	,birth_date
)VALUES ('김영희', 30, '1993-05-03');

-- point 컬럼을 지정하지 않아서 null이 들어간다
SELECT * FROM tbl_user;

-- 컬럼을 지정할때는 테이블의 컬럼 순서와 다르게 사용 가능하다
INSERT INTO tbl_user(
	age
	,name
	,birth_date
)VALUES (30, '김길동', '1993-05-03');

/*
 * UPDATE : 데이터를 수정한다(행을 수정한다)
 */

UPDATE tbl_user
SET age = 45;

-- 모든 행의 나이가 45살로 변경되어있다
SELECT * FROM tbl_user;

-- 이름이 김길동인 행의 나이를 30살로 변경한다
UPDATE tbl_user
SET age = 30
WHERE name = '김길동';

-- 포인트 금액이 입력이 안된 회원들은 0원으로 변경한다
UPDATE tbl_user
SET point = 0
WHERE point IS NULL;

-- 모든 멤버의 나이를 1살씩 증가
UPDATE tbl_user
SET age = age + 1;

-- 오늘이 생일인 멤버에게 포인트를 50 증가시킨다
UPDATE tbl_user
SET point = point + 50
WHERE to_char(birth_date, 'mmdd') = to_char(sysdate, 'mmdd');

-- extract() 함수
UPDATE tbl_user
SET point = point + 50
WHERE extract(MONTH FROM birth_date) = extract(MONTH FROM sysdate) -- 월을 비교
AND extract(DAY FROM birth_date) = extract(DAY FROM sysdate); -- 일을 비교

-- 서브쿼리도 사용가능
-- 나이가 제일 적은 회원에게 포인트 100 증가

-- 제일 적은 나이값을 구하기
SELECT min(age) FROM tbl_user;

UPDATE tbl_user
SET point = point + 100
WHERE age = (SELECT min(age) FROM tbl_user);

SELECT * FROM tbl_user;

/*
 * DELETE : 데이터를 삭제한다(행을 삭제한다)
 */
-- 나이가 31살인 멤버를 삭제한다
DELETE FROM tbl_user
WHERE age = 31;

-- 조건식을 사용하지 않으면 모든 데이터가 삭제된다-> 모든 행을 삭제한다
DELETE FROM tbl_user;

/*
 * CREATE : 테이블을 생성한다
 */

DROP TABLE tbl_user;

CREATE TABLE tbl_user(
	user_id varchar2(100)
	,user_pw varchar2(100)
	,user_age NUMBER
	,user_email varchar2(100)
	,user_point varchar2(100)
);

-- user_password가 아닌 user_pw로 컬럼명을 작성했다
-- user_point 컬럼을 숫자가 아닌 문자로 작성했다
SELECT * FROM tbl_user;





