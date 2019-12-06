SELECT *
FROM dept;

--dept ���̺� �μ���ȣ 99, �μ��� ddit, ��ġ daejeon
INSERT INTO dept VALUES(99,'ddit','daejeon');
commit;

--UPDATE : ���̺� ����� �÷��� ���� ����
--UPDATE ���̺�� SET �÷���1 = �����Ϸ��� �ϴ� ��1, �÷���2 = �����Ϸ��� �ϴ� ��2.....
--[WHERE  row ��ȸ ����] <- []�� �������ְ� �ȵ����� �ְ� ��� ��
--��ȸ ���ǿ� �ش��ϴ� �����͸� ������Ʈ�� �ȴ�

--�μ���ȣ�� 99���� �μ��� �μ����� ���IT��, ������ ���κ������� ����
UPDATE dept SET dname = '���IT', loc = '���κ���'
WHERE deptno = 99;
commit;
--������Ʈ���� ������Ʈ �Ϸ����ϴ� ���̺��� WHERE���� ����� �������� SELECT�� �Ͽ�
--������Ʈ ��� ROW�� Ȯ���غ���.
SELECT *
FROM dept
WHERE deptno = 99;

--���� ������ �����ϸ� WHERE���� ROW ���� ������ ���⶧����
--dept ���̺��� ��� �࿡ ���� �μ���, ��ġ ������ �����Ѵ�
UPDATE dept SET dname = '���IT', loc = '���κ���';

--Subquery�� �̿��� UPDATE
--emp ���̺� �ű� ������ �Է�
--�����ȣ 9999, ����̸� brown, ���� : null
INSERT INTO emp(empno, ename) VALUES (9999, 'brown');
commit;

SELECT *
FROM emp;

--�����ȣ�� 9999�� ����� �Ҽ� �μ��� �������� SMITH����� �μ�, ������ ������Ʈ
UPDATE emp SET deptno = (SELECT deptno FROM emp WHERE ename = 'SMITH'),
               job = (SELECT job FROM emp WHERE ename = 'SMITH')
WHERE empno = 9999;

commit;

SELECT *
FROM emp
WHERE empno = 9999;

--DELETE : ���ǿ� �ش��ϴ� ��ROW�� ������
--�÷��� ���� ����??(NULL)������ �����Ϸ��� -->UPDATE�ؾ���

--DELETE ���̺��
--[WHERE ����]

--UPDATE������ ���������� DELETE ���� ���������� �ش� ���̺��� WHERE������ �����ϰ� �Ͽ�
--SELECT�� ����, ������ ROW�� ���� Ȯ���غ���

--emp���̺� �����ϴ� �����ȣ 9999�� ����� ����
DELETE emp
WHERE empno = 9999;
commit;
-- DELETE emp; <- emp ���̺� ��ü ����

SELECT *
FROM emp
WHERE empno = 9999;

--�Ŵ����� 7698�� ��� ����� ����
--���������� ���
SELECT empno
FROM emp
WHERE mgr = 7698;


DELETE emp
WHERE empno IN( SELECT empno
                FROM emp
                WHERE mgr = 7698);
rollback;
--�� ������ �Ʒ� ������ ������                
DELETE emp WHERE mgr = 7698;                

SELECT *
FROM emp;

--ISOLATION LEVEL2
--���� Ʈ�����ǿ��� ���� ������
--(FOR UPDATE)�� ����, ���� ��������

UPDATE dept SET dname = 'ddit'
WHERE deptno = 99;

--BOSTON 40
SELECT *
FROM dept
WHERE deptno = 40
FOR UPDATE;

SELECT *
FROM dept;
--�ٸ� Ʈ����ǿ��� ������ ���ϱ� ������
--�� Ʈ����ǿ��� �ش� ROW�� �׻� ������ ��������� ���� �� �� �ִ�.
SELECT *
FROM dept;
--������ ���� Ʈ����ǿ��� �ű� ������ �Է���
-- commit�� �ϸ� �� Ʈ����ǿ��� ��ȸ�� �ȴ� (phantom read)

--ISOLATION LEVEL3
--SERIALIZABLE READ
--Ʈ������� ������ ��ȸ ������ Ʈ����� ���� �������� ��������
-- �� ���� Ʈ����ǿ��� �����͸� �ű� �Է�, ����, ���� �� commit�� �ϴ���
--���� Ʈ����ǿ����� �ش� �����͸� ���� �ʴ´�.

--Ʈ����� ���� ����(serializable read)
SET TRANSACTION isolation LEVEL SERIALIZABLE;

DELETE dept WHERE deptno = 99;
SELECT *
FROM dept;

--dept ���̺� �ó���� �����Ͽ� (d)
SELECT *
FROM dept;

--DDL : TABLE ����
--CREATE TABLE [����ڸ�.] ���̺��(
--            �÷���1 �÷�Ÿ��1,
--            �÷���1 �÷�Ÿ��2, ....
--            �÷���N �÷�Ÿ��N);
-- ranger_no NUMBER             : ������ ��ȣ
-- ranger_name VARCHAR2(50)     : ������ �̸�
-- reg_dt DATE                  : ������ �������
--���̺� ���� DDL : Data Defination Language(������ ���Ǿ�)
-- DDL�� rollback�� ����( �ڵ�Ŀ�� �ǹǷ� rollback�� �� �� ����)
CREATE TABLE ranger(
            ranger_no NUMBER,
            ranger_name VARCHAR2(50),
            reg_dt DATE);
rollback; -- �ѹ� �ȵ�.   DDL ������ rollback ó�� �Ұ�!!!!
DESC ranger;

SELECT *
FROM user_tables
WHERE table_name = 'RANGER';
--WHERE table_name = 'ranger'; <- ����Ŭ������ ��ü ������ �ҹ��ڷ� �����ϴ���
-- ���������δ� �빮�ڷ� �����Ѵ�.

INSERT INTO ranger VALUES(1, 'brown', sysdate);
--�����Ͱ� ��ȸ�Ǵ� ���� Ȯ�� ����
SELECT * 
FROM ranger;

--DML���� DDL�� �ٸ��� rollback�� �����ϴ�
rollback;

--rollback�� �߱� ������ DML������ ��ҵȴ�
SELECT *
FROM ranger;

--DATE Ÿ�Կ��� �ʵ� �����ϱ�
--EXTRACT(�ʵ�� FROM �÷�/expression)
SELECT TO_CHAR(sysdate, 'yyyy')yyyy,
       TO_CHAR(sysdate, 'mm') mm,
       EXTRACT(year FROM SYSDATE)ex_yyyy,
       EXTRACT(month FROM SYSDATE)ex_mm,
       EXTRACT(day FROM SYSDATE)ex_day
FROM dual;

--���̺� ������ �÷� ���� �������� ����
CREATE TABLE dpet_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13));
    
DROP TABLE dpet_test;    

CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13));
    
    DESC dept_test;
--dept_test ���̺��� dpetno �÷��� PRIMARY KEY ���������� �ֱ� ������
--deptno�� �����ѵ����͸� �Է��ϰų� ���� �� �� ����
--���� �������̹Ƿ� �Է¼���
INSERT INTO dept_test VALUES(99, 'ddit','datjeon');

--dept_test �����Ϳ� eeptno�� 99���� �����Ͱ� �����Ƿ�
--primary key �������ǿ� ���� �Է� �� �� ����
--���� ���� -
--ORA-00001: unique constraint (SJSJ.SYS_C007106) violated <- �������Ƕ����� ����
-- SYS_C007106 ���������� � ���� �������� �Ǵ��ϱ� ����Ƿ�
--�������ǿ� �̸��� �ڵ� �꿡 ���� �ٿ� �ִ� ���� ���������� ���ϴ�.
INSERT INTO dept_test VALUES(99, '���','����');

--���̺� ������ �������� �̸��� �߰��Ͽ� �����
--primary key : pk_���̺��
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2) CONSTRAINT pk_dept_test PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13));

INSERT INTO dept_test VALUES(99, 'ddit','datjeon');
INSERT INTO dept_test VALUES(99, '���','����');
--���� ���� -
--ORA-00001: unique constraint (SJSJ.PK_DEPT_TEST) violated <- pk_dept_test��� �������ǿ� �̸��� �ٿ��� ������ �˾ƺ��� ����
