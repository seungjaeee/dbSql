--INDEX만 조회하여 사용자의 요구사항에 만족하는 데이터를 만들어 낼 수 있는 경우

SELECT rowid, emp.*
FROM emp;

SELECT empno, rowid
FROM emp;

--emp 테이블의 모든 컬럼을 조회
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 2949544139
 
--------------------------------------------------------------------------------------
| Id  | Operation                   | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |        |     1 |    38 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP    |     1 |    38 |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_EMP |     1 |       |     0   (0)| 00:00:01 |
--------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782)

--emp 테이블의 empno 컬럼을 조회
EXPLAIN PLAN FOR
SELECT empno
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);

--기존 인덱스 제거(PK_emp 제약조건 삭제) --> UNIQUE 제약 삭제 --> pk_emp 인덱스 삭제)

--INDEX 종류 (컬럼 중복 여부)
--UNIQUE INDEX : 인덱스 컬럼의 값이 중복될 수 없는 인덱스(emp.empno,dept.deptno)
-- NON-UNIQUE INDEX(dafault) : 인덱스 컬럼의 값이 중복될 수 있는 인덱스 (emp.job)
ALTER TABLE emp DROP CONSTRAINT pk_emp;

--CREATE UNIQUE INDEX idx_n_emp_01 ON emp (empno); <- 유니크인덱스생성

--위쪽 상황이랑 달라진 것은 empno컬럼으로 생성된 인덱스가
-- UNIQUE -> NON-UNIQUE 인덱스로 변경됨
CREATE INDEX idx_n_emp_01 ON emp (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 2778386618
 
--------------------------------------------------------------------------------------------
| Id  | Operation                   | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |              |     1 |    38 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP          |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_N_EMP_01 |     1 |       |     1   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782)
   
--7782
DELETE emp WHERE empno = 9999;
INSERT INTO emp (empno, ename) VALUES (7782,'brown');

SELECT *
FROM emp
WHERE empno = 7782;

--dept 테이블에는 PK_dept (PRIMARY KEY 제약 조건이 설정됨)
--PK_dept : deptno로 PRIMARY KEY 제약이 걸려있음 (중복된 값이 올수 없고 NULL이 있을수 없다 값이 반드시 들어가야한다)
SELECT *
FROM dept;
INSERT INTO dept VALUES (20, 'ddit3','대전');

SELECT *
FROM user_cons_columns
WHERE TABLE_NAME ='DEPT';

--emp 테이블에 job 컬럼으로 non-unique 인덱스 생성
--인덱스명 : idx_n_emp_02
CREATE INDEX idx_n_emp_02 ON emp (job);

SELECT job, rowid
FROM emp, dept
ORDER BY job;

--emp 테이블에는 인덱스가 현재 두개 존재 하고있음
--1번째 인덱스 : empno
--2번째 인덱스 : job

SELECT *
FROM emp
WHERE job = 'MANAGER';

--IDX_02 인덱스
--1번째 인덱스 : empno
--2번째 인덱스 : job
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

--idx_n_emp_03
--emp 테이블의 job, ename 컬럼으로 non-unique 인덱스 생성
CREATE INDEX idx_n_emp_03 ON emp (job, ename); --컬럼순서 중요

SELECT job,ename, rowid
FROM emp
ORDER BY job, ename;

--idx_n_emp_04
-- ename, job 컬럼으로 emp 테이블에 non-unique 인덱스 생성    <- 위에꺼는 job,ename 이거는 ename,job 순서바뀜
CREATE INDEX idx_n_emp_04 ON emp(ename, job);
SELECT ename, job, rowid
FROM emp
ORDER BY ename, job;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE ename LIKE 'J%'
AND job = 'MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);

--JOIN 쿼리에서의 인덱스
--전제조건 : emp 테이블은 empno컬럼으로 PRIMARY KEY 제약조건이 존재
--dept 테이블은 deptno 컬럼으로 PRIMARY KEY 제약조건이 존재
--emp 테이블은 PRIMARY KEY 제약을 삭제한 상태이므로 재생성한다.
DELETE emp WHERE ename = 'brown';
commit;
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY(empno);

EXPLAIN PLAN FOR
SELECT ename, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.empno = 7788;

SELECT *
FROM TABLE(dbms_xplan.display);


--CREATE TABLE DEPT_TEST AS SELECT * FROM DEPT WHERE 1 = 1 구문으로
--DEPT_TEST 테이블 생성 후 조건에 맞는 인덱스 생성

--기존에 있던 dept_test 테이블 삭제
DROP TABLE dept_test;
--dept 테이블을 참조하여 dept_test 테이블 생성
CREATE TABLE dept_test AS
SELECT *
FROM dept
WHERE 1 = 1;

--deptno 컬럼으로 UNIQUE INDEX
CREATE UNIQUE INDEX idx_u_dept_test01 ON dept_test(deptno);

--dname 컬럼으로 NON-UNIQUE INDEX
CREATE INDEX idx_n_dept_test02 ON dept_test(dname);

--deptno, dname 컬럼으로 NON-UNIQUE INDEX
CREATE INDEX idx_n_dept_test03 ON dept_test(deptno, dname);

--idx2
--실습 idx1 에서 생성한 인덱스 삭제하는 DDL문 작성

DROP INDEX idx_u_dept_test01;
DROP INDEX idx_n_dept_test02;
DROP INDEX idx_n_dept_test03;

--과제
--exerd를 참고하여
--hr.exerd를 SJSJ 계정에 생성하는 쿼리를 작성
