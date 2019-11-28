--emp 테이블, dept 테이블 조인
EXPLAIN PLAN FOR
SELECT ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno  --연결고리
AND emp.deptno = 10;            --WHERE절에 어떤 조건이 있어도 실행결과는 동일하다

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 615168685
 
---------------------------------------------------------------------------
| Id  | Operation          | Name | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |      |    14 |   308 |     7  (15)| 00:00:01 |
|*  1 |  HASH JOIN         |      |    14 |   308 |     7  (15)| 00:00:01 |
|   2 |   TABLE ACCESS FULL| DEPT |     4 |    52 |     3   (0)| 00:00:01 |
|   3 |   TABLE ACCESS FULL| EMP  |    14 |   126 |     3   (0)| 00:00:01 |
---------------------------------------------------------------------------
 ↑↑↑↑↑↑↑↑↑↑↑↑↑↑ 순서는 2-3-1-0
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("EMP"."DEPTNO"="DEPT"."DEPTNO")



SELECT ename, deptno
FROM emp;

SELECT deptno, dname
FROM dept;

SELECT ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno != dept.deptno
AND emp.deptno = 10;

--natural join : 조인 테이블간 같은 타입, 같은이름의 컬럼으로
--               같은 값을 갖을 경우 조인
DESC emp;
DESC dept;

SELECT *
FROM emp NATURAL JOIN dept; 

ALTER TABLE emp DROP COLUMN dname; -- 컬럼 삭제

--ANSI SQL
SELECT deptno, emp.empno, ename
FROM emp NATURAL JOIN dept;

--oracle문법
SELECT emp.deptno, emp.empno, ename
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT a.deptno, empno, ename --ORA-00918: column ambiguously defined 어떤 테이블
FROM emp a, dept b          --테이블도 별칭을 지을 수 있음 (a랑 b)
WHERE a.deptno = b.deptno;

--JOUN USING
--join 하려고하는 테이블간 동일한 이름의 컬럼이 두개 이상일 때
--join 컬럼을 하나만 사용하고 싶을 때

--ANSI SQL
SELECT *
FROM emp JOIN dept USING (deptno) ;

--ORACLE SQL
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--ANSI JOIN wtih ON
--조인 하고자 하는 테이블의 컬럼 이름이 다를때
--개발자가 조인 조건을 직접 제어할 때

SELECT *
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

--ORACLE
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--SELF JOIN : 같은 테이블간 조인할 때
--emp 테이블간 조인 할만한 사항 : 직원의 관리자 정보 조회
--직원의 관리자 정보를 조회
--직원이름 , 관리자이름

--ANSI
--직원 이름, 직원의 상급자 이름, 직원의 상급자의 상급자 이름
SELECT e.ename, m.ename
FROM emp e JOIN emp m ON(e.mgr = m.empno);

--ORACLE
SELECT e.ename, m.ename -- 가져온 데이터중에 ename만 보이게 하겠다
FROM emp e, emp m
WHERE e.mgr = m.empno; --e.mgr과 m.empno에서 일치하는 데이터만 가져오겠따

SELECT ename, mgr
FROM emp;

--직원이름, 직원의 관리자 이름, 직원의 관리자의 관리자 이름
SELECT e.ename, m.ename, t.ename
FROM emp e, emp m, emp t
WHERE e.mgr = m.empno
AND m.mgr = t.empno;


--직원이름, 직원의 관리자 이름, 직원의 관리자의 관리자 이름, 직원의 관리자의 관리자의 관리자 이름
SELECT e.ename, m.ename, p.ename, t.ename
FROM emp e, emp m, emp p, emp t
WHERE e.mgr = m.empno
AND m.mgr = p.empno
AND p.mgr = t.empno;

--여러개의 테이블을 ANSI JOIN을 이용한 JOIN
SELECT e.ename, m.ename, t.ename, k.ename
FROM emp e JOIN emp m ON ( e.mgr = m.empno)
     JOIN emp t ON ( m.mgr = t.empno)
     JOIN emp k ON ( t.mgr = k.empno);
     
--직원의 이름과, 해당 직원의 관리자 이름을 조회한다
--단 직원의 사번이 7369~7698인 직원을 대상으로 조회
SELECT e.ename, m.ename, e.empno
FROM emp e, emp m
WHERE e.mgr = m.empno
AND e.empno BETWEEN 7369 AND 7698;

SELECT s.ename, m.ename
FROM emp s, emp m
WHERE s.empno BETWEEN 7369 AND 7698
AND s.mgr = m.empno;

SELECT s.ename, m.ename
FROM emp s JOIN emp m ON( s.mgr = m.empno )
WHERE s.empno BETWEEN 7369 AND 7698;

--NON_EQUI JOIN : 조인 조건이 =(equal)이 아닌 JOIN
-- != , BETWEEN AND

SELECT *
FROM salgrade;

SELECT sal, ename, empno
FROM emp;

SELECT empno, ename, sal, grade
FROM emp, salgrade
WHERE sal >= losal
AND sal <= hisal;


SELECT empno, ename, sal, grade
FROM emp, salgrade
WHERE sal BETWEEN losal AND hisal;

SELECT empno, ename, sal, grade
FROM emp JOIN salgrade ON sal BETWEEN losal AND hisal;


-- 연습해보기
--emp테이블과 dept테이블의 deptno 조인하기
SELECT empno, ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
ORDER BY emp.deptno;

--부서번호가 10,30번인 데이터만 조회
SELECT empno, ename, dept.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.deptno IN(10, 30);

--ANSI SQL
SELECT empno, ename, dept.deptno, dname
FROM emp JOIN dept ON emp.deptno = dept.deptno
WHERE emp.deptno IN (10, 30);

--급여가 2500 초과
SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND sal > 2500;

--ANSI SQL
SELECT empno, ename, dept.deptno, dname
FROM emp JOIN dept ON emp.deptno = dept.deptno
AND sal > 2500;

--급여 2500초과, 사번이 7600보다 큰 직원
SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND sal > 2500
AND empno > 7600;

--ANSI
SELECT empno, ename, sal, emp.deptno, dname
FROM emp JOIN dept ON emp.deptno = dept.deptno
AND sal > 2500 AND empno > 7600;

--급여 2500 초과, 사번이 7600보다 크고 부서명이 RESEARCH인 부서에 속한 직원
SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND sal > 2500 AND empno > 7600 AND dname = 'RESEARCH'
ORDER BY ename;

--ANSI
SELECT empno, ename, sal, emp.deptno, dname
FROM emp JOIN dept ON emp.deptno = dept.deptno
AND sal > 2500 AND empno > 7600 AND dname = 'RESEARCH'
ORDER BY ename;





