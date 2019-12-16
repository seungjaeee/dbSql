--GROUPING SETS(co1,co2)
--������ ����� ����
--�����ڰ� GROUP BY�� ������ ���� ����Ѵ�
--ROLLUP�� �޸� ���⼺�� ���� �ʴ´�
--GROUPING SETS(co1,co2)

-- GROUP BY col1
--UNION ALL
--GROUP BY col2

--emp ���̺��� ������ job�� �޿�(sal)+��(comm)��,
--                  deptno(�μ�)�� �޿�+�� �� ���ϱ�
--������� GROUP FUNCTION : 2���� sql �ۼ� �ʿ�(UNION , UNION ALL)
SELECT job,sum((sal) + NVL(comm,0)) sal_comm_sum
FROM emp
GROUP BY job
UNION ALL
SELECT '',deptno, sum((sal) + NVL(comm, 0)) sal
FROM emp
GROUP BY deptno;

--GROUPING SETS ������ �̿��Ͽ� ���� sql ���տ����� ������� �ʰ�
--���̺��� �ѹ� �о ó��
SELECT job, deptno, sum(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY GROUPING SETS (job,deptno);

-- job, deptno�� �׷����� �� sal+comm ��
-- mgr�� �׷����� �� sal+comm ��
--GROUP BY job, deptno
--UNIOB ALL
--GROUP BY mgr
--> GROUPING SETS((job, deptno), mgr)
SELECT job,deptno,mgr, sum(sal+NVL(comm,0)) sal_comm_sum,GROUPING(job),GROUPING(deptno),GROUPING(mgr)
FROM emp
GROUP BY GROUPING SETS((job,deptno),mgr);

--CUBE(co11, col2 ...)
--������ �÷��� ��� ������ �������� GROUP BY subset�� �����
--CUBE�� ������ �÷��� 2���� ��� : ������ ���� 4��
--CUBE�� ������ �÷��� 3���� ��� : ������ ���� 8��
--CUBE�� ������ �÷����� 2�� ������ �� ����� ������ ���� ������ �ȴ�.
--�÷��� ���ݸ� �������� ������ ������ ���ϱ޼������� �þ�� ������ ���� �Ⱦ�

--job, deptno�� �̿��Ͽ� cube ����
SELECT job,deptno, sum(sal + nvl(comm,0)) sal
FROM emp
GROUP BY CUBE(job,deptno);
-- job, deptno
-- 1, 1 --> GROUP BY job, deptno
-- 1, 0 -->GROUP BYjob
-- 0, 1 -->GROUP BY deptno
-- 0, 0 -->GROUP BY -- emp���̺��� �𽼈��� ���� GROUP BY

--GROUP BY ����
--GROUP BY, ROLLUP, CUBE�� ���� ����ϱ�
-- ������ ������ �����غ���, ���� ����� ���� �� �� �ִ�
--GROUP BY job, rollup(deptno), cube(mgr)
SELECT job, deptno, mgr, sum(sal + nvl(comm,0)) sal
FROM emp
GROUP BY job, ROLLUP(deptno), cube(mgr);

SELECT job, sum(sal)
FROm emp
GROUP BY job, job;


--dept���̺��� �̿��Ͽ� dept_test ���̺� ����
--dept_test ���̺� empcnt (NUMBER) �÷� ����
--���������� �̿��Ͽ� dept_test���̺��� empcnt �÷��� �ش� �μ��� ���� update�ϴ� ���� �ۼ�

CREATE TABLE dept_test AS
SELECT *
FROM dept_test;

ALTER TABLE dept_test ADD(empcnt NUMBER);

UPDATE dept_test SET empcnt = (SELECT count(*) 
                               FROM emp 
                               WHERE emp.deptno = dept_test.deptno);
rollback;

SELECT *
FROM dept_test;

DROP TABLE dept_test;

CREATE TABLE dept_test AS
SELECT *
FROM dept;

INSERT INTO dept_test values(99, 'it1', 'daejeon');
INSERT INTO dept_test values(98, 'it2', 'daejeon');

DELETE FROM dept_test
WHERE deptno NOT IN (SELECT deptno
                     FROM emp
                     WHERE emp.deptno = dept_test.deptno);


DELETE FROM dept_test
WHERE deptno NOT IN (SELECT deptno
                     FROM emp
                     WHERE deptno IN(10,20,30));
SELECT *
FROM emp;
SELECT *
FROM dept_test;
rollback;

SELECT *
FROM emp_test;
DROP TABLE emp_test;

CREATE TABLE emp_test AS
SELECT *
FROM emp;

SELECT deptno, ROUND(avg(sal),1) + 200
FROM emp
GROUP BY deptno;


UPDATE emp_test SET sal = sal + 200
WHERE sal < (SELECT avg(sal)
             FROM emp
             WHERE emp.deptno = emp_test.deptno);


SELECT deptno, avg(sal)
FROM emp_test
GROUP BY deptno;
-- MERGE ������ �̿��� ������Ʈ
MERGE INTO emp_test a
USING (SELECT deptno, avg(sal) avg_sal
       FROM emp_test
       GROUP BY deptno) b
ON (a.deptno = b.deptno)
WHEN MATCHED THEN
    UPDATE SET sal = sal + 200
    WHERE a.sal < avg_sal;
    
    
MERGE INTO emp_test a
USING (SELECT deptno, avg(sal) avg_sal
       FROM emp_test
       GROUP BY deptno) b
ON (a.deptno = b.deptno)
WHEN MATCHED THEN
    UPDATE SET sal = CASE
                        WHEN a.sal < b.avg_sal THEN sal + 200
                        ELSE sal
                    END;
SELECT *
FROM emp_test;
             
             rollback;


             





