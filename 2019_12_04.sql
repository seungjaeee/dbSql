--1.tax ���̺��� �̿� �õ�/�ñ����� �δ� �������� �Ű�� ���ϱ�
--2.�Ű���� ���� ������ ��ŷ �ο��ϱ�
--��ŷ �õ� �ñ��� �δ翬������ �Ű��
-- 1 ����Ư���� ���ʱ� 7000
-- 2 ����Ư���� ������ 6800
SELECT q.rn, q.sido, q.sigungu,�δ翬������Ű�� , w.sido, w.sigungu, ���ù�������
FROM
(SELECT ROWNUM rn, sido, sigungu, �δ翬������Ű��
FROM
(SELECT sido, sigungu, ROUND(sal / people, 1)�δ翬������Ű��
FROM tax
ORDER BY �δ翬������Ű�� DESC)) q

LEFT OUTER JOIN 

(SELECT ROWNUM rn, sido, sigungu, ���ù�������
FROM
(SELECT  a.sido, a.sigungu, ROUND(a.cnt/b.cnt, 1) ���ù�������
FROM
(SELECT sido,sigungu, count(*) cnt --����ŷ, KFC, �Ƶ����� �Ǽ�
FROM fastfood
WHERE gb IN('KFC','����ŷ','�Ƶ�����')
GROUP BY sido,sigungu) a,

(SELECT sido,sigungu, count(*) cnt --�Ե����� �Ǽ�
FROM fastfood
WHERE gb IN('�Ե�����')
GROUP BY sido,sigungu) b
WHERE a.sido = b.sido
AND a.sigungu = b.sigungu
ORDER BY ���ù������� DESC))w ON ( q.rn = w.rn)

ORDER BY q.rn;

--���ù������� �õ�, �ñ����� �������� ���Աݾ��� �õ�, �ñ�����
-- ���� �������� ����
-- ���ļ����� tax ���̺��� id �÷������� ����
-- 1 ����Ư����  ������  5.6   ����Ư���� ������ 70.3

SELECT q.id, q.sido, q.sigungu,�δ翬������Ű�� , w.sido, w.sigungu, ���ù�������
FROM
(SELECT ROWNUM rn, id, sido, sigungu, �δ翬������Ű��
FROM
(SELECT id, sido, sigungu, ROUND(sal / people, 1)�δ翬������Ű��
FROM tax
ORDER BY �δ翬������Ű�� DESC)) q

LEFT OUTER JOIN 

(SELECT ROWNUM rn, sido, sigungu, ���ù�������
FROM
(SELECT  a.sido, a.sigungu, ROUND(a.cnt/b.cnt, 1) ���ù�������
FROM
(SELECT sido,sigungu, count(*) cnt --����ŷ, KFC, �Ƶ����� �Ǽ�
FROM fastfood
WHERE gb IN('KFC','����ŷ','�Ƶ�����')
GROUP BY sido,sigungu) a,

(SELECT sido,sigungu, count(*) cnt --�Ե����� �Ǽ�
FROM fastfood
WHERE gb IN('�Ե�����')
GROUP BY sido,sigungu) b
WHERE a.sido = b.sido
AND a.sigungu = b.sigungu
ORDER BY ���ù������� DESC))w ON (q.sido = w.sido AND w.sigungu = q.sigungu )
ORDER BY q.id;


--SMITH�� ���� �μ� ã��
SELECT deptno
FROM emp
WHERE ename = 'SMITH';

SELECT *
FROM emp;
WHERE deptno = (SELECT deptno
               FROM emp
               WHERE ename = 'SMITH');

SELECT empno, ename, deptno, 
       (SELECT dname FROM dept WHERE dept.deptno = emp.deptno) dname
FROM emp;

--SCALAR SUBQUERY
--SELECT ���� ǥ���� ���� ����
--�� ��, �� COLUMN�� ��ȸ�ؾ� �Ѵ�
SELECT empno, ename, deptno, 
       (SELECT dname FROM dept) dname
FROM emp;

--INLINE VIEW
--FROM���� ���Ǵ� ��������

--SUBQUERY
--WHERE ���� ���Ǵ� ��������
SELECT COUNT(*) cnt
FROM emp
WHERE sal > (SELECT AVG(sal)
            FROM emp);
            
--��ձ޿����� ���� ���� �޴� �������� ������ȸ
SELECT empno, ename, job, mgr, hiredate, sal, comm, deptno
FROM emp
WHERE sal > (SELECT AVG(sal)
            FROM emp);

--SMITH�� WARD����� ���� �μ��� ��� ��� ������ ��ȸ�ϴ� ������ �ۼ��ϼ���

SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                 FROM emp
                 WHERE ename IN('SMITH','WARD'));

--1.SMITH, WARD�� ���� �μ� ��ȸ --> 20, 30
--2. 1���� ���� ������� �̿��Ͽ� �ش� �μ���ȣ�� ���ϴ� ���� ��ȸ


SELECT *
FROM emp
WHERE deptno IN(20,30);

--SMITH Ȥ�� WARD ���� �޿��� ���Թ޴� ������ȸ

SELECT *
FROM emp
WHERE sal < ALL(SELECT sal --800, 1250 --> 1250���� �������
                FROM emp 
                WHERE ename IN('SMITH','WARD'));
                
--������ ������ ���� �ʴ� ��� ���� ��ȸ
--NOT IN ������ ���� NULL�� �����Ϳ� �������� �ʾƾ� ������ �Ѵ�
SELECT *
FROM emp -- ��� ���� ��ȸ --> �����ڿ����� ���� �ʴ�
WHERE empno NOT IN( SELECT nvl(mgr,-1) --NULL ���� �������� �������� �����ͷ� ġȯ
                FROM emp);

SELECT *
FROM emp -- ��� ���� ��ȸ --> �����ڿ����� ���� �ʴ�
WHERE empno NOT IN( SELECT mgr --NULL ���� �������� �������� �����ͷ� ġȯ
                FROM emp
                WHERE mgr IS NOT NULL);

--pairwise (���� �÷��� ���� ���ÿ� ���� �ؾ��ϴ� ���)
--ALLEN�� CLARK�� �Ŵ����� �μ���ȣ�� ���ÿ� ���� ��� ���� ��ȸ
--7698, 30
--7839, 10
SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN(7499, 7782));

--�Ŵ����� 7698 �̰ų� 7839 �̸鼭
--�ҼӺμ��� 10�� �̰ų� 30���� ���� ���� ��ȸ
--7698, 10
--7698, 30
--7839, 10
--7839, 30
SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN(7499, 7782))
AND deptno IN (SELECT deptno
               FROM emp
               WHERE empno IN(7499, 7782));
               
--���ȣ ���� ���� ����
--���������� �÷��� ������������ ������� �ʴ� ������ ���� ���l

--���ȣ ���� ���������� ��� ������������ ����ϴ� ���̺�, �������� ��ȸ ������ 
--���������� ������������ �Ǵ��Ͽ� ������ �����Ѵ�.
--���������� emp ���̺��� ���� �������� �ְ�, ���������� emp ���̺��� ���� ���� ���� �ִ�.

--���ȣ ���� ������������ ���������� ���̺��� ���� ��������
--���������� �����ڿ����� �ߴ� ��� �� �������� ǥ��
--���ȣ ���� ������������ ���������� ���̺��� ���߿� ��������
--���������� Ȯ���� ������ �ߴ� ��� �� �������� ǥ��

--������ �޿� ��պ��� ���� �޿��� �޴� ���� ���� ��ȸ
--������ �޿����
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);
             
--��ȣ���� ��������
--�ش������� ���� �μ��� �޿���պ��� ���� �޿��� �޴� ���� ��ȸ

SELECT *
FROM emp m
WHERE sal > (SELECT AVG(sal)
             FROM emp
             WHERE deptno = m.deptno);

--10���μ��� �޿����
SELECT AVG(sal)
FROM emp
WHERE deptno = 30;