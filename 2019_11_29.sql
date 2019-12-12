--emp, dept테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요( 급여 2500 초과, 사번이 7600보다 큰 직원)
SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND sal > 2500
AND empno > 7600;

--ANSI SQL
SELECT empno, ename, sal, emp.deptno, dname
FROM emp JOIN dept ON emp.deptno = dept.deptno
AND sal > 2500 
AND empno > 7600;

SELECT *
FROM prod;

SELECT *
FROM lprod;

--prod 와 lprod 테이블 조인
SELECT lprod_gu, lprod_nm, prod_id, prod_name
FROM prod, lprod
WHERE prod_lgu = lprod_gu;

--prod 와 buyer 테이블 조인
SELECT buyer_id, buyer_name, prod_id, prod_name
FROM prod, buyer
WHERE prod_buyer = buyer_id;


SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member, cart, prod
WHERE mem_id = cart_member
AND cart_prod = prod_id;


--join 실습 4
SELECT cycle.cid, cnm, pid, day, cnt
FROM customer, cycle
WHERE customer.cid = cycle.cid
AND cnm IN ('brown', 'sally');

--join 실습 5
SELECT cycle.cid,  product.pid, cnm, pnm, day, cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
AND cycle.pid = product.pid
AND cnm IN('brown', 'sally');

--join 실습 6
SELECT cycle.cid, cnm, product.pid, pnm, SUM(cnt) cnt                
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
AND cycle.pid = product.pid
GROUP BY cycle.cid,cnm,product.pid,pnm;

--join 실습 7
SELECT cycle.pid, pnm, SUM(cnt) cnt
FROM cycle, product
WHERE cycle.pid = product.pid
GROUP BY cycle.pid, pnm ;

--SELECT * 
--FROM DBA_USERS;
--
--ALTER USER HR ACCOUNT UNLOCK; --아이디 잠금 해제
--
--ALTER USER HR IDENTIFIED BY xxxx; --비밀번호설정

SELECT region_id,

