--�������� Ȱ��ȭ / ��Ȱ��ȭ
--ALTER TABLE ���̺�� ENABLE OR DISABLE �������Ǹ�;

SELECT *
FROM user_tables
WHERE TABLE_NAME = 'DEPT_TEST';

--dept_test ���̺��� PRIMARY KEY �������� ��Ȱ��ȭ
ALTER TABLE dept_test DISABLE CONSTRAINT SYS_C007123;

SELECT * 
FROM dept_test;

--dept_test ���̺��� deptno �÷��� ����� PRIMARY KEY ���������� ��Ȱ��ȭ �Ͽ�
--������ �μ���ȣ�� ���� �����͸� �Է��� �� �ִ�
INSERT INTO dept_test VALUES(99,'ddit','daejeon');
INSERT INTO dept_test VALUES(99,'DDIT','����');

--dept_test ���̺��� PRIMARY KEY �������� Ȱ��ȭ
--�̹� ������ ������ �ΰ��� INSERT ������ ���� ���� �μ���ȣ�� ���� �����Ͱ�
--�����ϱ� ������ PRIMARY KEY ���������� Ȱ��ȭ �� �� ����
--Ȱ��ȭ �Ϸ��� �ߺ������͸� ���� �ؾ��Ѵ�.
ALTER TABLE dept_test ENABLE CONSTRAINT SYS_C007123;


--�μ���ȣ�� �ߺ��Ǵ� �����͸� ��ȸ �Ͽ�
--�ش� �����Ϳ� ���� ������ PRIMARY KEY ���������� Ȱ��ȭ �� �� �ִ�
SELECT deptno, COUNT(*)
FROM dept_test
GROUP BY deptno
HAVING COUNT(*) >= 2;

--table_name, constraint_name, column_name
--position ���� (ASC)
SELECT *
FROM user_constraints
WHERE table_name = 'BUYER';

SELECT *
FROM user_cons_columns
WHERE table_name = 'BUYER';

--���̺� ���� ����(�ּ�) VIEW
SELECT *
FROM USER_TAB_COMMENTS;


--���̺� �ּ�
--COMMENT ON TABLE ���̺�� IS '�ּ�';
COMMENT ON TABLE dept IS '�μ�';

--�÷� �ּ�
--COMMENT ON COLUMN ���̺��,�÷��� IS '�ּ�';
COMMENT ON COLUMN dept.deptno IS '�μ���ȣ';
COMMENT ON COLUMN dept.dname IS '�μ���';
COMMENT ON COLUMN dept.loc IS '�μ���ġ ����';

SELECT *
FROM USER_COL_COMMENTS
WHERE TABLE_NAME = 'DEPT';

--user_tab_comments, user_col_comments view�� �̿��Ͽ�
--customer, product, cycle, daily ���̺�� �÷��� �ּ������� ��ȸ�ϴ� ������ �ۼ��϶�
SELECT a.table_name, a.table_type, a.comments tab_comment, b.column_name, b.comments COL_comment
FROM user_tab_comments a, user_col_comments b
WHERE a.TABLE_NAME = b.TABLE_NAME
AND a.TABLE_NAME IN('CUSTOMER','PRODUCT','CYCLE','DAILY'); --���̺��̸��� ORACLE ������ �빮�ڷ� ������


--�Ʒ��� user_tab_comments �� user_col_comments �� ���� �Ұ��� �ִ��� Ȯ�ο�
SELECT *
FROM user_tab_comments;
SELECT *
FROM user_col_comments;

--VIEW : QUERY�̴� (O)
--���̺� ó�� �����Ͱ� ���������� ���� �ϴ� ���� �ƴϴ�.
--���� ������ �� = QUERY
--VIEW�� ���̺� �̴� (X)

--VIEW ����
--CREATE OR REPLACE VIEW ���̸� [(�÷���Ī1,�÷���Ī2...)] AS
--SUBQUERY

--emp���̺��� sal, comm �÷��� ������ ������ 6�� �÷��� ��ȸ���Ǵ� view��
--v_emp�̸����� ����
CREATE OR REPLACE VIEW v_emp AS
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;

desc emp;

--SYSTEM �������� �۾���
--VIEW ���� ������ SJSJ ������ �ο�
GRANT CREATE VIEW TO SJSJ;

SELECT *
FROM v_emp;

--INLINE VIEW
SELECT *
FROM ( SELECT empno, ename, job, mgr, hiredate, deptno
        FROM emp);
        
--emp���̺��� �����ϸ� view�� ������ ������?
--KING�� �μ���ȣ�� ���� 10��
--emp ���̺��� KING�� �μ���ȣ �����͸� 30������ ����
--v_emp ���̺��� KING�� �μ���ȣ�� ����

--�׻� ������Ʈ �� ������ȸ
SELECT *
FROM emp
WHERE ename = 'KING';

UPDATE emp SET deptno = 30
WHERE ename = 'KING';
--KING�� �μ���ȣ�� 30������ �ٲ� ( VIEW�� ������ �� )
SELECT *
FROM v_emp;
rollback;

CREATE OR REPLACE VIEW v_emp_dept AS
SELECT emp.empno, emp.ename, dept.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT *
FROM v_emp_dept;

--emp ���̺��� KING������ ����(commit ���� �� ��)
SELECT *
FROM emp
WHERE ename = 'KING';

DELETE emp
WHERE ename = 'KING';

--emp ���̺��� KING ������ ���� �� v_emp_dpet view �� ��ȸ ���Ȯ��
SELECT *
FROM v_emp_dept;
rollback;
--INLINE VIEW
SELECT *
        FROM (SELECT emp.empno, emp.ename, dept.deptno, dept.dname
        FROM emp, dept
        WHERE emp.deptno = dept.deptno);
       
--VIEW ����
--v_emp ����
DROP VIEW v_emp;    

--�μ��� ������ �޿� �հ�
CREATE OR REPLACE VIEW v_emp_sal AS
SELECT deptno, SUM(sal) sum_sal
FROM emp
GROUP BY deptno;

SELECT *
FROM v_emp_sal;

SELECT *
FROM v_emp_sal
WHERE deptno = 20;

SELECT *
FROM (SELECT deptno, SUM(sal) sum_sal
FROM emp
GROUP BY deptno);

--SEQUENCE
--����Ŭ��ü�� �ߺ����� �ʴ� ���� ���� �������ִ� ��ü
--CREATE SEQUENCE �������� 
--[�ɼ�...]

CREATE SEQUENCE seq_board;


--������ ����� : ��������.nextval
--������-����
SELECT TO_CHAR(sysdate,'yyyymmdd') ||'-' ||seq_board.nextval
FROM dual;

SELECT seq_board.currval
FROM dual;

SELECT rowid, rownum, emp.*
FROM emp;

--emp ���̺� empno �÷����� PRIMARY KEY  ������� : PK_emp
--dept ���̺� deptno �÷����� PRIMARY KEY  ������� : PK_dept
--emp ���̺��� deptno �÷��� dept ���̺��� deptno �÷��� �����ϵ���
--FOREIGN KEY ���� �߰� : fk_dept_emp
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
ALTER TABLE dept ADD CONSTRAINT pk_dept PRIMARY KEY (deptno);
ALTER TABLE emp ADD CONSTRAINT fk_dept_deptno FOREIGN KEY(deptno)
            REFERENCES dept (deptno);

--emp_test ���̺� ����
DROP TABLE emp_test;

--emp���̺��� �̿��Ͽ� emp_test ���̺� ����
CREATE TABLE emp_test AS
SELECT *
FROM emp;
            
SELECT rowid, rownum, emp.*
FROM emp;

--emp_test ���̺��� �ε����� ���� ����
--���ϴ� �����͸� ã�� ���ؼ��� ���̺��� �����͸� ��� �о���� �Ѵ�
EXPLAIN PLAN FOR --�����ȹ
SELECT *
FROM emp_test
WHERE empno = 7369;

SELECT *
FROM table(dbms_xplan.display);

--�����ȹ�� ���� 7369 ����� ���� ���� ������ ��ȸ �ϱ�����
--���̺��� ��� ������(14��)�� �о� �������� �纯�� 7369�� �����͸� �����Ͽ�
--����ڿ��� ��ȯ
--**13���� �����ʹ� ���ʿ��ϰ� ��ȸ �� ����

Plan hash value: 3124080142
 
------------------------------------------------------------------------------
| Id  | Operation         | Name     | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |          |     1 |    87 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP_TEST |     1 |    87 |     3   (0)| 00:00:01 |
------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("EMPNO"=7369)
 
Note
-----
   - dynamic sampling used for this statement (level=2)
   
   
   EXPLAIN PLAN FOR --�����ȹ
SELECT *
FROM emp
WHERE empno = 7369;

SELECT *
FROM table(dbms_xplan.display);

--�����ȹ�� ���� �м��� �ϸ�
--empno�� 7369�� ������ index�� ���� �ſ� ������ �ε����� ����
--���� ����Ǿ� �ִ� rowid�� ���ؼ� table�� �����Ѵ�
--table���� ���� �����ʹ� 7369��� ������ �ѰǸ� ��ȸ�� �ϰ�
--������ 13�ǿ� ���ؼ��� �����ʰ�ó��
-- 14 --> 1
-- 1 --> 1
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
 
   2 - access("EMPNO"=7369)

EXPLAIN PLAN FOR   
SELECT rowid, emp.*
FROM emp
WHERE rowid = 'AAAE5uAAFAAAAETAAA';

SELECT *
FROM table(dbms_xplan.display);









