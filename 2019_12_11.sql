--INDEX�� ��ȸ�Ͽ� ������� �䱸���׿� �����ϴ� �����͸� ����� �� �� �ִ� ���

SELECT rowid, emp.*
FROM emp;

SELECT empno, rowid
FROM emp;

--emp ���̺��� ��� �÷��� ��ȸ
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

--emp ���̺��� empno �÷��� ��ȸ
EXPLAIN PLAN FOR
SELECT empno
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);

--���� �ε��� ����(PK_emp �������� ����) --> UNIQUE ���� ���� --> pk_emp �ε��� ����)

--INDEX ���� (�÷� �ߺ� ����)
--UNIQUE INDEX : �ε��� �÷��� ���� �ߺ��� �� ���� �ε���(emp.empno,dept.deptno)
-- NON-UNIQUE INDEX(dafault) : �ε��� �÷��� ���� �ߺ��� �� �ִ� �ε��� (emp.job)
ALTER TABLE emp DROP CONSTRAINT pk_emp;

--CREATE UNIQUE INDEX idx_n_emp_01 ON emp (empno); <- ����ũ�ε�������

--���� ��Ȳ�̶� �޶��� ���� empno�÷����� ������ �ε�����
-- UNIQUE -> NON-UNIQUE �ε����� �����
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

--dept ���̺��� PK_dept (PRIMARY KEY ���� ������ ������)
--PK_dept : deptno�� PRIMARY KEY ������ �ɷ����� (�ߺ��� ���� �ü� ���� NULL�� ������ ���� ���� �ݵ�� �����Ѵ�)
SELECT *
FROM dept;
INSERT INTO dept VALUES (20, 'ddit3','����');

SELECT *
FROM user_cons_columns
WHERE TABLE_NAME ='DEPT';

--emp ���̺� job �÷����� non-unique �ε��� ����
--�ε����� : idx_n_emp_02
CREATE INDEX idx_n_emp_02 ON emp (job);

SELECT job, rowid
FROM emp, dept
ORDER BY job;

--emp ���̺��� �ε����� ���� �ΰ� ���� �ϰ�����
--1��° �ε��� : empno
--2��° �ε��� : job

SELECT *
FROM emp
WHERE job = 'MANAGER';

--IDX_02 �ε���
--1��° �ε��� : empno
--2��° �ε��� : job
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

--idx_n_emp_03
--emp ���̺��� job, ename �÷����� non-unique �ε��� ����
CREATE INDEX idx_n_emp_03 ON emp (job, ename); --�÷����� �߿�

SELECT job,ename, rowid
FROM emp
ORDER BY job, ename;

--idx_n_emp_04
-- ename, job �÷����� emp ���̺� non-unique �ε��� ����    <- �������� job,ename �̰Ŵ� ename,job �����ٲ�
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

--JOIN ���������� �ε���
--�������� : emp ���̺��� empno�÷����� PRIMARY KEY ���������� ����
--dept ���̺��� deptno �÷����� PRIMARY KEY ���������� ����
--emp ���̺��� PRIMARY KEY ������ ������ �����̹Ƿ� ������Ѵ�.
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


--CREATE TABLE DEPT_TEST AS SELECT * FROM DEPT WHERE 1 = 1 ��������
--DEPT_TEST ���̺� ���� �� ���ǿ� �´� �ε��� ����

--������ �ִ� dept_test ���̺� ����
DROP TABLE dept_test;
--dept ���̺��� �����Ͽ� dept_test ���̺� ����
CREATE TABLE dept_test AS
SELECT *
FROM dept
WHERE 1 = 1;

--deptno �÷����� UNIQUE INDEX
CREATE UNIQUE INDEX idx_u_dept_test01 ON dept_test(deptno);

--dname �÷����� NON-UNIQUE INDEX
CREATE INDEX idx_n_dept_test02 ON dept_test(dname);

--deptno, dname �÷����� NON-UNIQUE INDEX
CREATE INDEX idx_n_dept_test03 ON dept_test(deptno, dname);

--idx2
--�ǽ� idx1 ���� ������ �ε��� �����ϴ� DDL�� �ۼ�

DROP INDEX idx_u_dept_test01;
DROP INDEX idx_n_dept_test02;
DROP INDEX idx_n_dept_test03;

--����
--exerd�� �����Ͽ�
--hr.exerd�� SJSJ ������ �����ϴ� ������ �ۼ�
