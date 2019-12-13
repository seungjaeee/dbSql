SELECT *
FROM emp_test
ORDER BY empno;

--emp���̺� �����ϴ� �����͸� emp_test ���̺�� ����
--���� empno�� ������ �����Ͱ� �����ϸ� ename update : ename || '_merge'
--���� empno�� ������ �����Ͱ� �������� �������
--emp���̺��� empno, ename emp_test �����ͷ� insert
DELETE emp_test
WHERE empno >= 7788;
commit;

--emp ���̺��� 14���� �����Ͱ� ����
--emp_test ���̺��� ����� 7788���� ���� 7���� �����Ͱ� ����
--emp���̺��� �̿��Ͽ� emp_test ���̺��� �����ϰԵǸ�
--emp ���̺��� �����ϴ� ���� ( ����� 7788���� ũ�ų� ����) 7��
--emp_test�� ���Ӱ� insert�� �� ���̰�
--emp,emp_test�� �����ȣ�� �����ϰ� �����ϴ� 7���� �����ʹ�(����� 7788���� ���� ����)
--ename�÷��� ename || '_modify'�� ������Ʈ
/*
MERGE INTO ���̺��
USING ������� ���̺� | VIEW | SUBQUERY
ON (���̺��� ��������� �������)
WHEN MATCHED THEN
    UPDATE ....
WHEN NOT MATCHED THEN
    INSERT ....
*/

MERGE INTO emp_test
USING emp
ON (emp.empno = emp_test.empno)
WHEN MATCHED THEN
    UPDATE SET ename = ename || '_mod'
WHEN NOT MATCHED THEN
    INSERT VALUES(emp.empno, emp.ename);
    
SELECT *
FROM emp_test;

-- emp_test ���̺� ����� 9999�� �����Ͱ� �����ϸ�
-- ename�� 'brown'���� update
-- �������� ���� ��� empno, ename VALUES (9999, 'brown')���� insert
-- ���� �ó������� MERGE ������ Ȱ���Ͽ� �ѹ��� sql�� ����
--:empno - 9999, :ename - 'brown'
MERGE INTO emp_test
USING dual
ON (emp_test.empno = :empno)
WHEN MATCHED THEN
    UPDATE SET ename = 'brown' || '_mod'
WHEN NOT MATCHED THEN
    INSERT VALUES(:empno, :ename);

SELECT *
FROM emp_test
WHERE empno= 9999;

--���� merge ������ ���ٸ� 
-- 1. empno = 9999�� �����Ͱ� �����ϴ��� Ȯ���ؾ���
-- 2-1. 1�����׿��� �����Ͱ� �����ϸ� UPDATE
-- 2-2. 1�����׿��� �����Ͱ� �������� ������ INSERT


--GROUP_AD1  (����sql 17p)

SELECT deptno, SUM(sal)
FROM emp
GROUP BY deptno

UNION ALL

SELECT null,SUM(sal)
FROM emp;

--JOIN �������
--emp ���̺��� 14���� �����͸� 28������ ����
--������(1 -14��, 2 -14��)�� �������� group by
--������ 1 : �μ���ȣ �������� group 14�� row
--������ 2 : ��ü 14�� row
SELECT DECODE(b.rn, 1, emp.deptno, 2, null) gp,
        SUM(emp.sal) sal
FROM emp, (SELECT ROWNUM rn
           FROM dept
           WHERE ROWNUM <= 2)b
GROUP BY DECODE(b.rn, 1, emp.deptno, 2, null)
ORDER BY DECODE(b.rn, 1, emp.deptno, 2, null);

--REPORT GROUP BY
--ROLLUP
--GROUP BY ROLLUP(col1..col2....)
--ROLLUP���� ����� �÷��� �����ʿ������� ���� �����
--SUB GROUP�� �����Ͽ� �������� GROUP BY���� �ϳ��� SQL���� ���� �ǵ��� �Ѵ�
GROUP BY ROLLUP(job, deptno)
-- GROUP BY job, deptno
-- GROUP BY job
-- GROUP BY  <-- ��ü ���� ������� GROUP BY


--emp���̺��� �̿��Ͽ� �μ���ȣ��, ��ü������ �޿����� ���ϴ� ������
--ROLLUP ����� �̿��Ͽ� �ۼ�
SELECT deptno, SUM(sal) sal
FROM emp
GROUP BY ROLLUP(deptno);

-- emp ���̺��� �̿��Ͽ� job, deptno �� sal + comm �հ�
--                   job �� sal + comm �հ�
--                  ��ü������ sal + comm �հ�
--   ROLLUP�� Ȱ���Ͽ� �ۼ�
SELECT job, deptno, SUM(sal + NVL(comm,0))sal_sum
FROM emp
--ROLLUP�� �÷� ������ ��ȸ ����� ������ ��ģ��
GROUP BY ROLLUP(job, deptno);
--GROUP BY job, deptno
--GROUP BY job
--GROUP BY --> ��ü row ���

GROUP BY ROLLUP(deptno, job);
--GROUP BY deptno, job
--GROUP BY deptno
--GROUP BY --> ��ü row ���
SELECT nvl(job,'�Ѱ�') job,deptno,SUM(sal)
FROM emp
GROUP BY ROLLUP(job, deptno);
--GROUP BY ROLLUP(deptno, job);

SELECT nvl(job,'��') job, 
    CASE
        WHEN deptno IS NULL AND job IS NULL THEN '��'
        WHEN deptno IS NULL THEN'�Ұ�'
        ELSE TO_CHAR(deptno) --'' || deptno
    END deptno,
        SUM(sal)   
FROM emp
GROUP BY ROLLUP(job, deptno);




SELECT deptno,job,SUM(sal + nvl(comm,0))sal
FROM emp
GROUP BY ROLLUP(deptno, job);
--GROUP BY ROLLUP(job, deptno);

--UNION ALL�� ġȯ

SELECT deptno,job,SUM(sal + nvl(comm,0))sal
FROM emp
GROUP BY deptno, job

UNION ALL

SELECT deptno, null,SUM(sal + nvl(comm,0))sal
FROM emp
GROUP BY deptno

UNION ALL
SELECT null, null, SUM(sal + nvl(comm, 0)) sal
FROM emp;


SELECT deptno,job,SUM(sal + nvl(comm,0))sal
FROM emp
GROUP BY ROLLUP(deptno, job);

--GROUP AD4 pt27
SELECT dname, job, SUM(sal + nvl(comm,0))sal
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY ROLLUP(dname, job);

SELECT a.deptno, job, sal
FROM
(SELECT deptno,job,SUM(sal + nvl(comm,0))sal
FROM emp
GROUP BY ROLLUP(deptno, job))a, dept
WHERE a.deptno = dept.deptno(+);

--GROUP AD5 pt28
SELECT nvl(dname,'����')dname,job,SUM(sal + nvl(comm,0))sal
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY ROLLUP(dname,job);


SELECT nvl(dname,'�Ѱ�'), job, sal
FROM
(SELECT deptno,job,SUM(sal + nvl(comm,0))sal
FROM emp
GROUP BY ROLLUP(deptno, job))a, dept
WHERE a.deptno = dept.deptno(+);



SELECT *
FROM dept;













