SELECT *  --dept ���̺� ��ȸ
FROM dept;

DESC emp; --<- emp���̺��� �����͵��� Ÿ���� Ȯ����.(����,���� ��)



--���⵵ �ǰ����� ����ڸ� ��ȸ�ϴ� ���� �ۼ�
SELECT empno, ename,hiredate,
            CASE
                WHEN MOD(TO_CHAR(hiredate, 'yyyy'), 2) =
                     MOD(TO_CHAR(SYSDATE, 'YYYY')+1, 2)
                THEN '�ǰ����� �����'
                ELSE '�ǰ����� ������'
                
            END
FROM emp;

SELECT empno, ename, hiredate,
            CASE
                WHEN MOD(TO_CHAR(hiredate, 'yyyy'), 2) =
                     MOD(TO_CHAR(SYSDATE, 'yyyy')+1, 2)
                THEN '�ǰ����� �����'
                ELSE '�ǰ����� ������'
            END
FROM emp;

SELECT userid, usernm, alias, reg_dt,
        CASE
            WHEN reg_dt IS NULL
            THEN '�ǰ����� ������'
            ELSE '�ǰ����� �����'
        END contact_to_doctor
FROM users;

SELECT a.userid, a.usernm, a.alias, a.reg_dt,
       DECODE(MOD(a.yyyy, 2), MOD(a.this_yyyy, 2), '�ǰ��������', '�ǰ���������') contacttodoctor
FROM
(SELECT a.*
FROM
(SELECT userid, usernm, alias, TO_CHAR(reg_dt, 'yyyy') yyyy,
       TO_CHAR(SYSDATE, 'yyyy') this_yyyy
FROM users)a);

--GROUP FUNCTION
--Ư�� �÷��̳�, ǥ���� �������� �������� ���� ������ ����� ����
--COUNT �Ǽ�, SUM �հ�, AVG ���, MAX �ִ밪, MIN �ּҰ�
--��ü ������ ������� (14�� -> 1��)

DESC emp;
SELECT MAX(sal) m_sal, --���� ���� �޿�
       MIN(sal) min_sal, --���� ���� �޿�
       ROUND(AVG(sal), 2) avg_sal, --�� ������ �޿� ���
       SUM(sal) sum_sal, --�� ������ �޿� ��
       COUNT(sal) count_sal, --�޿� �Ǽ� (null�� �ƴ� ���̸� 1��)
       COUNT(mgr) count_mgr, --���� ������ �Ǽ� (KING�� ��� MGR�� ����)
       COUNT(*) count_row --Ư�� �÷��� �Ǽ��� �ƴ϶� ���� ������ �˰� ������
FROM emp;

--�μ���ȣ���� �׷��Լ� ����
SELECT deptno,
       MAX(sal) m_sal, --�μ����� ���� ���� �޿�
       MIN(sal) min_sal, --�μ��������� ���� �޿�
       ROUND(AVG(sal), 2) avg_sal, --�μ� ������ �޿� ���
       SUM(sal) sum_sal, --�μ� ������ �޿� ��
       COUNT(sal) count_sal, --�μ��� �޿� �Ǽ� (null�� �ƴ� ���̸� 1��)
       COUNT(mgr) count_mgr, --�μ� ������ ���� ������ �Ǽ� (KING�� ��� MGR�� ����)
       COUNT(*) count_row --�μ��� ������ ��

FROM emp
GROUP BY deptno;

SELECT deptno, ename,
       MAX(sal) m_sal, --�μ����� ���� ���� �޿�
       MIN(sal) min_sal, --�μ��������� ���� �޿�
       ROUND(AVG(sal), 2) avg_sal, --�μ� ������ �޿� ���
       SUM(sal) sum_sal, --�μ� ������ �޿� ��
       COUNT(sal) count_sal, --�μ��� �޿� �Ǽ� (null�� �ƴ� ���̸� 1��)
       COUNT(mgr) count_mgr, --�μ� ������ ���� ������ �Ǽ� (KING�� ��� MGR�� ����)
       COUNT(*) count_row --�μ��� ������ ��
FROM emp
GROUP BY deptno, ename;

--SELECT ������ GROUP BY ���� ǥ���� �÷� �̿��� �÷��� �� �� ����
--�������� ������ ���� ���� (3���� ���� ������ �Ѱ��� �����ͷ� �׷���)
--��, ���������� ��������� SELECT ���� ǥ���� ����
SELECT deptno, 1, '���ڿ�', SYSDATE,
       MAX(sal) m_sal, --�μ����� ���� ���� �޿�
       MIN(sal) min_sal, --�μ��������� ���� �޿�
       ROUND(AVG(sal), 2) avg_sal, --�μ� ������ �޿� ���
       SUM(sal) sum_sal, --�μ� ������ �޿� ��
       COUNT(sal) count_sal, --�μ��� �޿� �Ǽ� (null�� �ƴ� ���̸� 1��)
       COUNT(mgr) count_mgr, --�μ� ������ ���� ������ �Ǽ� (KING�� ��� MGR�� ����)
       COUNT(*) count_row --�μ��� ������ ��
FROM emp
GROUP BY deptno;

--�׷��Լ������� NULL �÷��� ��꿡�� ���ܵȴ�
--emp���̺��� comm�÷��� null�� �ƴ� �����ʹ� 4���� ����, 9���� NULL
SELECT COUNT(comm) count_comm, --NULL�� �ƴ� ���� ���� 4
       SUM(comm) sum_comm,
       SUM(sal) sum_sal,--NULL���� ����, 300+500+1400+0 = 2200
       SUM(sal + comm) tot_sal_sum,
       SUM(sal + NVL(comm, 0)) tot_sal_sum1
FROM emp;

--WHERE ������ GROUP �Լ��� ǥ�� �� �� ����
--�μ��� �ִ� �޿� ���ϱ�
--�μ��� �ִ� �޿� ���� 3000�� �Ѵ� �ุ ���ϱ�
--deptno, �ִ�޿�
SELECT deptno, MAX(sal) max_sal
FROM emp
WHERE MAX(sal) > 3000 -- ORA-00934 : WHERE ������ GROUP �Լ��� �� �� ����
GROUP BY deptno;

SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno
HAVING MAX(sal) >= 3000;

        
        
        
        
        
        
        
SELECT MAX(sal) m_sal, --�μ����� ���� ���� �޿�
       MIN(sal) min_sal, --�μ��������� ���� �޿�
       AVG(sal) avg_sal, --�μ� ������ �޿� ���
       SUM(sal) sum_sal, --�μ� ������ �޿� ��
       COUNT(sal) count_sal, --�μ��� �޿� �Ǽ� (null�� �ƴ� ���̸� 1��)
       COUNT(mgr) count_mgr, --�μ� ������ ���� ������ �Ǽ� (KING�� ��� MGR�� ����)
       COUNT(*) count_all --�μ��� ������ ��
FROM emp;

--�� ������ �μ���ȣ �������� ������ �ۼ��ϼ��� (�޿� ����� �Ҽ��� ��°�ڸ����� ��������)
SELECT deptno, 
       MAX(sal) m_sal,
       MIN(sal) min_sal,
       ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(sal) count_sal,
       COUNT(mgr) count_mgr,
       COUNT(*) count_all
FROM emp
GROUP BY deptno;


--�� �������� �ۼ��� ������ Ȱ���Ͽ� deptno ��� �μ����� ���ü� �ֵ��� �����ϼ���
SELECT CASE
            WHEN deptno = 10 THEN 'ACCOUNTING'
            WHEN deptno = 20 THEN 'RESEARCH'
            WHEN deptno = 30 THEN 'SALES'
       END dname,
       MAX(sal) m_sal,
       MIN(sal) min_sal,
       ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(sal) count_sal,
       COUNT(mgr) count_mgr,
       COUNT(*) count_all
FROM emp
GROUP BY deptno;

SELECT DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES') dname,
       MAX(sal) m_sal,
       MIN(sal) min_sal,
       ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(sal) count_sal,
       COUNT(mgr) count_mgr,
       COUNT(*) count_all
FROM emp
GROUP BY deptno
ORDER BY deptno;

--emp���̺��� �̿��Ͽ� ������ �Ի� ������� ����� ������ �Ի��ߴ��� ��ȸ�ϴ� ������ �ۼ��ϼ���

--hiredate �÷��� ���� yyyymm �������� �����
--date Ÿ���� ���ڿ��� ����(yyyymm)
SELECT TO_CHAR(hiredate, 'yyyymm') hire_yyyymm, COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'yyyymm');

SELECT hire_yyyymm, count(*) cnt
FROM
    (SELECT TO_CHAR(hiredate, 'YYYYMM') hire_yyyymm
    FROM emp)
GROUP BY hire_yyyymm;

--emp���̺��� �̿��Ͽ� ������ �Ի� �⺰�� ����� ������ �Ի��ߴ��� ��ȸ�ϴ� ������ �ۼ��ϼ���
SELECT TO_CHAR(hiredate, 'yyyy') hire_yyyy, COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'yyyy');

--dept���̺��� �μ� �� ���ϱ�
SELECT COUNT(*) cnt, COUNT(deptno), COUNT(loc)
FROM dept;

DESC dept;

--������ ���� �μ��� ������ ��ȸ�ϴ� ����(emp���̺� ���)
SELECT COUNT(deptno) cnt
FROM
(SELECT deptno
FROM emp
GROUP BY deptno);

SELECT COUNT(COUNT(deptno)) cnt --ī��Ʈ�� �ι� ����Ҽ��� �ִ�.
FROM emp
GROUP BY deptno;

SELECT COUNT(DISTINCT deptno) cnt
FROM emp;

--JOIN
--1.���̺� ��������(�÷� �߰�)
--2.�߰��� �÷��� ���� update
--3.dname �÷��� emp ���̺� �߰�
DESC dept;

--�÷��߰�(dname, VARCHAR2(14))
ALTER TABLE emp ADD (dname VARCHAR2(14));
DESC emp;

SELECT *
FROM emp;

UPDATE emp SET dname = CASE     --UPDATE ������Ʈ�� ���̺� SET ������Ʈ�� �÷���
                            WHEN deptno = 10 THEN 'ACCOUNTING'
                            WHEN deptno = 20 THEN 'RESEARCH'
                            WHEN deptno = 30 THEN 'SALES'
                        END;
commit;

SELECT empno, ename, deptno, dname
FROM emp;

-- SALES --> MARKET SALES
--�� 6���� ������ ������ �ʿ��ϴ�
--���� �ߺ��� �ִ� ����(�� ������)
UPDATE emp SET dname = 'MARKET SALES'   -- 'SALES' �� 'MARKET SALES' �� �ٲٱ�
WHERE dname = 'SALES';  

--emp ���̺�, dept ���̺� ����
SELECT ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;
