
CREATE UNIQUE INDEX idx_u_emp00 ON emp(mgr,empno);
CREATE INDEX idx_n_emp02 ON emp(ename);
CREATE INDEX idx_n_emp01 ON emp(deptno);


EXPLAIN PLAN FOR
SELECT b.*
FROM emp a, emp b
WHERE a.mgr = b.empno
AND a.deptno = :deptno;

EXPLAIN PLAN FOR
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.deptno = :deptno
AND emp.empno LIKE :empno ||'%';

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE sal BETWEEN :st_sal ANd :ed_sal
AND deptno = :deptno;

SELECT *
FROM TABLE(dbms_xplan.display);

EXPLAIN PLAN FOR
SELECT b.*
FROM emp A, emp B
WHERE A.mgr = B.empno
AND A.deptno = :deptno



