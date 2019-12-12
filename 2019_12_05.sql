INSERT INTO dept VALUES (99,'ddit','daejeon');
commit;

--dept ���̺��� �ű� ��ϵ� 99�� �μ��� ���� ����� ���� ������ ������ ���� �μ��� ��ȸ�ϴ� ������ �ۼ�
SELECT *
FROM dept
WHERE deptno NOT IN (SELECT deptno 
                     FROM emp);

--cycle, product ���̺��� �̿��Ͽ� cid = 1 �� ���� �������� �ʴ� ��ǰ�� ��ȸ�ϴ� ������ �ۼ�
SELECT *
FROM product
WHERE pid NOT IN (SELECT pid
                  FROM cycle
                  WHERE cid = 1);
--1�� ���� �Դ� ��ǰ ( 100, 400 )
SELECT pid
FROM cycle
WHERE cid = 1;

--cycle ���̺��� �̿��Ͽ� cid=1�� ���� �����ϴ� ��ǰ�� cid=2�� ���� �����ϴ� ��ǰ�� ���������� ��ȸ�ϴ� ����
SELECT *
FROM cycle
WHERE cid = 1
AND pid IN( SELECT pid
            FROM cycle
            WHERE cid = 2);

SELECT *
FROM cycle
WHERE cid = 1;

--cycle,customer,product ���̺��� �̿��Ͽ� cid=1�� ���� �����ϴ� ��ǰ�� cid=2�� ���� �����ϴ� ��ǰ�� ���������� ��ȸ�ϰ� ����� ��ǰ�����
-- �����ϴ� ����
SELECT cycle.cid, customer.cnm, cycle.pid, product.pnm, cycle.day, cycle.cnt
FROM cycle, customer, product
WHERE cycle.cid = 1
AND cycle.cid = customer.cid
AND cycle.pid = product.pid
AND cycle.pid IN(SELECT pid FROM cycle WHERE cid = 2);

SELECT cycle.cid, customer.cnm, cycle.pid, product.pnm, cycle.day, cycle.cnt
FROM cycle, customer, product
WHERE cycle.cid = customer.cid
AND product.pid = cycle.pid
AND cycle.cid = 1
AND cycle.pid IN( SELECT pid
                  FROM cycle
                  WHERE cid = 2);

--�Ŵ����� �����ϴ� ���� ���� ��ȸ
SELECT *
FROM emp e
WHERE EXISTS(SELECT 1 FROM emp m WHERE m.empno = e.mgr);

SELECT a.*
FROM emp a, emp b
WHERE a.mgr = b.empno;

SELECT *
FROM emp
WHERE mgr IS NOT NULL; --mgr�� ���� -> ���� NULL�̴�

SELECT *
FROM product
WHERE EXISTS(SELECT pid
             FROM cycle
             WHERE cid = 1
             AND  cycle.pid = product.pid);


SELECT *
FROM product
WHERE NOT EXISTS(SELECT pid
             FROM cycle
             WHERE cid = 1
             AND  cycle.pid = product.pid);

SELECT pid
FROM cycle
WHERE cid = 1;

--���տ���
--UNION : ������, �� ������ �ߺ����� �����Ѵ�
--�������� SALESMAN�� ������ ������ȣ, ���� �̸� ��ȸ
--���Ʒ� ������� �����ϱ� ������ ������ ������ �ϰ� �ɰ��
--�ߺ��Ǵ� �����ʹ� �ѹ��� ǥ���Ѵ�
SELECT empno, ename
FROM emp
WHERE job = 'SALESMAN'

UNION

SELECT empno, ename
FROM emp
WHERE job = 'SALESMAN';


--���� �ٸ� ������ ������
SELECT empno, ename
FROM emp
WHERE job = 'SALESMAN'

UNION

SELECT empno, ename
FROM emp
WHERE job = 'CLERK';

SELECT *
FROM emp;


-- UNION ALL
-- ������ ����� �ߺ� ���Ÿ� ���� �ʴ´�
-- ���Ʒ� ��� ���� �ٿ��ֱ⸸ �Ѵ�
SELECT empno, ename
FROM emp
WHERE job = 'SALESMAN'

UNION ALL

SELECT empno, ename
FROM emp
WHERE job = 'SALESMAN';


--���տ���� ���ռ��� �÷��� ���� �ؾ��Ѵ�
--�÷��� ������ �ٸ���� ������ ���� �ִ� ������� ������ �����ش�
SELECT empno, ename, '' --          �̰�ó�� �Ѧ�
FROM emp
WHERE job = 'SALESMAN'

UNION ALL

SELECT empno, ename, job
FROM emp
WHERE job = 'SALESMAN';

--INTERSECT : ������
--�� ���հ� �������� �����͸� ��ȸ
SELECT empno, ename
FROM emp
WHERE job IN('SALESMAN','CLERK')

INTERSECT

SELECT empno, ename
FROM emp
WHERE job IN('SALESMAN');

--MINUS
--������ : ��, �Ʒ� ������ �������� �� ���տ��� ������ ������ ��ȸ
--�������� ��� ������, �����հ� �ٸ��� ������ ���� ������ ��� ���տ� ������ �ش�
SELECT empno, ename
FROM emp
WHERE job IN('SALESMAN','CLERK')

MINUS

SELECT empno, ename
FROM emp
WHERE job IN('SALESMAN');


--*�� ��ȸ�� ORDER BY ename�� �ν����� ���ϴ� ����
SELECT empno, ename
FROM
(SELECT empno, ename
FROM emp
WHERE job IN('SALESMAN','CLERK')
ORDER BY job)

UNION ALL

SELECT empno, ename
FROM emp
WHERE job IN('SALESMAN')
ORDER BY ename;



--DML
--INSERT : ���̺� ���ο� �����͸� �Է�
SELECT *
FROM dept;

DELETE dept 
WHERE deptno = 99;
commit;

--INSERT �� �÷��� ������ ���
--������ �÷��� ���� �Է��� ���� ������ ������ ����Ѵ�
--INSERT INTO ���̺�� (�÷�1,�÷�2....)
--              VALUES (��1, ��2....)
--dept ���̺� 99�� �μ���ȣ, ddit ������, daejeon �������� ���� ������ �Է�
INSERT INTO dept (deptno, dname, loc)
            VALUES (99,'ddit','daejeon');        
rollback;
--�÷��� ����� ��� ���̺��� �÷� ���� ������ �ٸ��� �����ص� ����� ����
--dept ���̺��� �÷� ���� : deptno, dname, location
INSERT INTO dept (loc, deptno, dname)
            VALUES ('daejeon',99,'ddit');
            
--�÷��� ������� �ʴ°�� : ���̺��� �÷� ���� ������ ���� ���� ����Ѵ�       
INSERT INTO dept VALUES (99,'ddit','daejeon');

DESC emp;

--��¥ �� �Է��ϱ�
--1.SYSDATE
--2.����ڷκ��� ���� ���ڿ��� DATE Ÿ������ �����Ͽ� �Է�

INSERT INTO emp VALUES ( 9998,'sally','SALESMAN',NULL, SYSDATE, 500, NULL, NULL);

--2019�� 12�� 2�� �Ի�
INSERT INTO emp VALUES ( 9998,'sally','SALESMAN',NULL, TO_DATE('20191202', 'yyyymmdd'), 500, NULL, NULL);
SELECT * 
FROM emp;
rollback;

--�������� �����͸� �ѹ��� �Է�
--SELECT ����� ���̺� �Է� �� �� �ִ�.
INSERT INTO emp
SELECT 9998,'sally','SALESMAN',NULL, SYSDATE, 500, NULL, NULL
FROM dual
UNION ALL
SELECT 9997,'james','CLERK',NULL, TO_DATE('20191202', 'yyyymmdd'), 500, NULL, NULL
FROM dual;

