--OUTER join : 조인 연결에 실패 하더라도 기준이 되는 테이블의 데이터는
-- 나오도록 하는 join
--LEFT OUTER join : 테이블1 LEFT OUTER JOIN 테이블2
--테이블1과 테이블2를 조인할때 조인에 실패하더라도 테이블1쪽의 데이터는 조회가 되도록 한다.
--조인에 실패한 행에서 테이블2의 컬럼값은 존재하지 않으므로 NULL로 표시된다.
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m 
            ON (e.mgr = m.empno);

--그냥 조인
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e JOIN emp m 
            ON (e.mgr = m.empno);

--
SELECT e.empno, e.ename, m.empno, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m 
            ON (e.mgr = m.empno AND m.deptno = 10);
            
SELECT e.empno, e.ename, m.empno, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m 
            ON (e.mgr = m.empno )
WHERE m.deptno = 10;

--ORACLE SQL로 outer join
--일반조인과 차이점은 컬럼명에 (+) 표시
--(+)표시 : 데이터가 존재하지 않는데 나와야 하는 테이블의 컬럼
-- 직원 LEFT OUTER JOIN 매니저
--  ON(직원tb.매니저번호 = 매니저tb.직원번호)
-- ORACLE OUTER에서는
-- WHERE 직원tb.매니저번호 = 매니저tb.직원번호(+) -- 매니저쪽 데이터가 존재하지 않음

--ANSI
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m 
            ON (e.mgr = m.empno);
            
--ORACLE
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m 
WHERE e.mgr = m.empno(+);

--매니저 부서번호 제한
--ANSI SQL - WHERE절에 기술한 형태
-- --> OUTER 조인이 적용되지 않은 상황
-- 아우터 조인이 적용되어야 하는 테이블 모든 컬럼에 (+)가 붙어야 된다.
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m 
WHERE e.mgr = m.empno(+)
AND m.deptno(+) = 10;

--ANSI sql의 on절에 기술한 경우와 동일
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m 
WHERE e.mgr = m.empno(+)
AND m.deptno(+) = 10;
           
--emp 테이블에는 14명의 직원이 있고 14명은 10, 20 , 30 부서중에 한 부서에 속한다.
-- 하지만 dept테이블에는 10,20,30,40번 부서가 존재
--부서번호, 부서명 ,해당부서에 속한 직원수가 나오도록 존재
--부서번호, 부서명, 해당부서에 속한 직원수가 나오도록 쿼리를 작성
/*
10 ACCOUNTING 3 
20 RESEARCH   5
30 SALES      6
40 OPERATION  0
*/

SELECT dept.deptno, dept.dname, COUNT(emp.deptno) cnt
FROM emp, dept
WHERE emp.deptno(+) = dept.deptno
GROUP BY dept.deptno, dept.dname;

-- dept : deptno, dname
-- inline : dpetno, cnt(직원의 수)
SELECT dept.deptno, dept.dname, NVL(emp_cnt.cnt, 0) cnt
FROM
dept,
(SELECT deptno, COUNT(*) cnt
FROM emp
GROUP BY deptno) emp_cnt
WHERE dept.deptno = emp_cnt.deptno(+);

--ANSI 
SELECT dept.deptno, dept.dname, NVL(emp_cnt.cnt, 0) cnt
FROM
dept LEFT OUTER JOIN (SELECT deptno, COUNT(*) cnt
                      FROM emp 
                      GROUP BY deptno) emp_cnt 
                      ON(dept.deptno = emp_cnt.deptno);
                     
               
               
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m 
            ON (e.mgr = m.empno);

--RIGHT OUTER JOIN            
SELECT e.empno, e.ename, m.empno, m.ename  --RIGHT는 기준이되는 테이블 이오른쪽에옴
FROM emp e RIGHT OUTER JOIN emp m 
            ON (e.mgr = m.empno);

--FULL OUTER : LEFT OUTER + RIGHT OUTER -> 중복데이터 한건만 남기기
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e FULL OUTER JOIN emp m 
            ON (e.mgr = m.empno);

--OUTER JOIN 1
SELECT a.buy_date, a.buy_prod, prod.prod_id, prod.prod_name, a.buy_qty
FROM buyprod a, prod
WHERE a.buy_prod(+) = prod.prod_id
AND a.buy_date (+) = '20050125';

--OUTER JOIN 2
SELECT nvl(TO_CHAR(a.buy_date, 'yy/mm/dd'), '05/01/25') , a.buy_prod, prod.prod_id, prod.prod_name, a.buy_qty
FROM buyprod a, prod
WHERE a.buy_prod(+) = prod.prod_id
AND a.buy_date (+) = '20050125';


--OUTER JOIN 3
SELECT nvl(TO_CHAR(a.buy_date, 'yyyy/mm/dd'), '2005/01/25') , a.buy_prod, prod.prod_id, prod.prod_name, nvl(a.buy_qty, 0) 
FROM buyprod a, prod
WHERE a.buy_prod(+) = prod.prod_id
AND a.buy_date (+) = '20050125';

SELECT *
FROM cycle;
SELECT *
FROM product;

--OUTER JOIN 4
SELECT product.pid, product.pnm, nvl(cycle.cid,0)cid, nvl(cycle.day, 0) day, nvl(cycle.cnt,0) cnt
FROM cycle, product
WHERE product.pid = cycle.pid(+)
AND cycle.cid(+) = '1';

SELECT product.pid, product.pnm, nvl(cycle.cid,0)cid, nvl(cycle.day, 0) day, nvl(cycle.cnt,0) cnt
FROM cycle RIGHT OUTER JOIN product ON product.pid = cycle.pid
AND cycle.cid = '1';

--OUTER JOIN 5
SELECT product.pid, product.pnm, nvl(cycle.cid,1)cid, customer.cnm, nvl(cycle.day, 0) day, nvl(cycle.cnt,0) cnt
FROM cycle, product, customer
WHERE product.pid = cycle.pid(+)
AND cycle.cid(+) = '1'
AND customer.cnm IN ('brown');












SELECT *
FROM customer;
SELECT *
FROM cycle;
SELECT * 
FROM product;