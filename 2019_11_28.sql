--emp ���̺�, dept ���̺� ����
EXPLAIN PLAN FOR
SELECT ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno  --�����
AND emp.deptno = 10;            --WHERE���� � ������ �־ �������� �����ϴ�

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
 ��������������� ������ 2-3-1-0
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

--natural join : ���� ���̺� ���� Ÿ��, �����̸��� �÷�����
--               ���� ���� ���� ��� ����
DESC emp;
DESC dept;

SELECT *
FROM emp NATURAL JOIN dept; 

ALTER TABLE emp DROP COLUMN dname; -- �÷� ����

--ANSI SQL
SELECT deptno, emp.empno, ename
FROM emp NATURAL JOIN dept;

--oracle����
SELECT emp.deptno, emp.empno, ename
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT a.deptno, empno, ename --ORA-00918: column ambiguously defined � ���̺�
FROM emp a, dept b          --���̺� ��Ī�� ���� �� ���� (a�� b)
WHERE a.deptno = b.deptno;

--JOUN USING
--join �Ϸ����ϴ� ���̺� ������ �̸��� �÷��� �ΰ� �̻��� ��
--join �÷��� �ϳ��� ����ϰ� ���� ��

--ANSI SQL
SELECT *
FROM emp JOIN dept USING (deptno) ;

--ORACLE SQL
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--ANSI JOIN wtih ON
--���� �ϰ��� �ϴ� ���̺��� �÷� �̸��� �ٸ���
--�����ڰ� ���� ������ ���� ������ ��

SELECT *
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

--ORACLE
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--SELF JOIN : ���� ���̺� ������ ��
--emp ���̺� ���� �Ҹ��� ���� : ������ ������ ���� ��ȸ
--������ ������ ������ ��ȸ
--�����̸� , �������̸�

--ANSI
--���� �̸�, ������ ����� �̸�, ������ ������� ����� �̸�
SELECT e.ename, m.ename
FROM emp e JOIN emp m ON(e.mgr = m.empno);

--ORACLE
SELECT e.ename, m.ename -- ������ �������߿� ename�� ���̰� �ϰڴ�
FROM emp e, emp m
WHERE e.mgr = m.empno; --e.mgr�� m.empno���� ��ġ�ϴ� �����͸� �������ڵ�

SELECT ename, mgr
FROM emp;

--�����̸�, ������ ������ �̸�, ������ �������� ������ �̸�
SELECT e.ename, m.ename, t.ename
FROM emp e, emp m, emp t
WHERE e.mgr = m.empno
AND m.mgr = t.empno;


--�����̸�, ������ ������ �̸�, ������ �������� ������ �̸�, ������ �������� �������� ������ �̸�
SELECT e.ename, m.ename, p.ename, t.ename
FROM emp e, emp m, emp p, emp t
WHERE e.mgr = m.empno
AND m.mgr = p.empno
AND p.mgr = t.empno;

--�������� ���̺��� ANSI JOIN�� �̿��� JOIN
SELECT e.ename, m.ename, t.ename, k.ename
FROM emp e JOIN emp m ON ( e.mgr = m.empno)
     JOIN emp t ON ( m.mgr = t.empno)
     JOIN emp k ON ( t.mgr = k.empno);
     
--������ �̸���, �ش� ������ ������ �̸��� ��ȸ�Ѵ�
--�� ������ ����� 7369~7698�� ������ ������� ��ȸ
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

--NON_EQUI JOIN : ���� ������ =(equal)�� �ƴ� JOIN
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


-- �����غ���
--emp���̺�� dept���̺��� deptno �����ϱ�
SELECT empno, ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
ORDER BY emp.deptno;

--�μ���ȣ�� 10,30���� �����͸� ��ȸ
SELECT empno, ename, dept.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.deptno IN(10, 30);

--ANSI SQL
SELECT empno, ename, dept.deptno, dname
FROM emp JOIN dept ON emp.deptno = dept.deptno
WHERE emp.deptno IN (10, 30);

--�޿��� 2500 �ʰ�
SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND sal > 2500;

--ANSI SQL
SELECT empno, ename, dept.deptno, dname
FROM emp JOIN dept ON emp.deptno = dept.deptno
AND sal > 2500;

--�޿� 2500�ʰ�, ����� 7600���� ū ����
SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND sal > 2500
AND empno > 7600;

--ANSI
SELECT empno, ename, sal, emp.deptno, dname
FROM emp JOIN dept ON emp.deptno = dept.deptno
AND sal > 2500 AND empno > 7600;

--�޿� 2500 �ʰ�, ����� 7600���� ũ�� �μ����� RESEARCH�� �μ��� ���� ����
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





