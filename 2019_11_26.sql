--��¥���� �Լ�
--ROUND, TRUNC
--(MOTNHS_BETWEEM) ADD_MONTHS, NEXT_DAY
--LAST_DAY : �ش� ��¥�� ���� ���� ������ ����(DATE)

--�� : 1, 3, 5, 7, 8, 10, 12 : 31�ϱ���
--  : 2���� - ���� ���ο� ���� 28, 29
--  : 4, 6, 9, 11 : 30�ϱ���
SELECT SYSDATE, LAST_DAY(SYSDATE)
FROM dual;

--'201912' --> date Ÿ������ �����ϱ�
--�ش� ��¥�� ��������¥�� �̵�
--���� �ʵ常 �����ϱ�
--DATE --> �����÷�(DD)�� ����
--DATE --> ���ڿ�(DD)
--DATE : LAST_DAY(TO_DATE('201912', 'yyyymm'))
--���� : 'DD'
SELECT '201912' param, 
        TO_CHAR(LAST_DAY(TO_DATE('201912', 'yyyymm')), 'DD')dt
FROM dual;

SELECT 'yyyymm' param, 
        TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'yyyymm')), 'DD')dt
FROM dual;

--SYSDATE�� YYYY/MM/DD ������ ���ڿ��� ����
--'2019/11/26' ���ڿ� --> DATE
--���ڿ� : TO_CHAR(SYSDATE, 'YYYY/MM/DD') - 2019/11/26
SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD'),
       TO_DATE(TO_CHAR(SYSDATE, 'YYYY/MM/DD'), 'YYYY/MM/DD'),
       TO_CHAR(TO_DATE(TO_CHAR(SYSDATE, 'YYYY/MM/DD'), 'YYYY/MM/DD'), 'YYYY-MM-DD hh24:mi:ss')
FROM dual;

--EMPNO    NOT NULL NUMBER(4)    
--HIREDATE          DATE       
DESC emp;

--empno�� 7369�� ���� ������ȸ �ϱ�

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7369;

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    37 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    37 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("EMPNO"=7369)
   
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE TO_CHAR(empno) = 7369;

SELECT *
FROM TABLE(dbms_xplan.display);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7300 + '69'; -- 69 -> ���ڷ� ����

SELECT *
FROM TABLE(dbms_xplan.display);

--
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('1981/06/01', 'YYYY/MM/DD');

--DATEŸ���� ������ ����ȯ�� ����� ������ ����
--
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('81/06/01', ' RR/MM/DD');
--WHERE hiredate >= '81/06/01';

SELECT TO_DATE('50/05/05', 'RR/MM/DD'),
       TO_DATE('49/05/05', 'RR/MM/DD'),
       TO_DATE('50/05/05', 'YY/MM/DD'),
       TO_DATE('49/05/05', 'YY/MM/DD')
FROM dual;

--���� --> ���ڿ�
--���ڿ� --> ����
--���� : 1000000 --> 1,000,000 (����)
--���� : 1000000 --> 1.000.000,00 (����)
--��¥ ���� : YYYY, MM, DD, HH24, MI, SS
--���� ���� : ���� ǥ�� : 9, �ڸ������� ���� 0ǥ�� : 0, ȭ����� : L
--          1000�ڸ� ���� : , �Ҽ��� : .
--���� -> ���ڿ�      TO_CHAR(����, '����')
--���� ������ �������� ���� �ڸ����� ����� ǥ��
SELECT empno, ename, sal, TO_CHAR(sal, 'L009,999') fm_sal
FROM emp;

SELECT TO_CHAR(10000000000, 'L999,999,999,999,999')
FROM dual;

--NULL ó�� �Լ� : NVL, NVL2, NULLIF, COALESCE
--NVL(expr1, expr2) : �Լ� ���ڰ� �ΰ�
--expr1�� NULL �̸� expr2�� ��ȯ
--expr1�� NULL�� �ƴϸ� expr1�� ��ȯ

SELECT empno, ename, comm, NVL(comm, -1) nvl_comm --������ͺ��� �߿���������
FROM emp;

--NVL2(expr1, expr2, expr3)
--expr1 IS NOT NULL �̸� expr2 ����
--expr1 IS NULL �̸� expr3 ����
SELECT empno, ename, comm, NVL2(comm, 1000, -500) nvl2_comm,
       NVL2(comm, comm, -500) nvl_comm
FROM emp;

--NULLIF(expr1, expr2)
--expr1 = expr2 <-NULL�� ����
--expr1 != expr2 <-expr1�� ����
--comm�� NULL�϶� comm + 500 : NULL
--  NULLIF(NULL,NULL) : NULL
--comm�� NULL�� �ƴҶ� comm + 500 : comm + 500
--  NULLIF(comm, comm+500) : comm
SELECT empno, ename, comm, NULLIF(comm, comm+500) nullif_comm       
FROM emp;

--COALESCE(expr1, expr2, expr3....)
--�����߿� ù��°�� �����ϴ� NULL�� �ƴ� exprN�� ����
--expr1 IS NOT NULL �̸� expr1�� �����ϰ�
--expr1 IS NULL �̸� COALESCE(expr2,expr3 .....)
SELECT empno, ename, comm, sal, COALESCE(comm, sal) coal_sal
FROM emp;

SELECT *
FROM DBA_DATA_FILES;

--�Ʒ������� �������� ������ �ۼ��ϼ��� (NVL,NVL2,COALESCE �̿�)
empno   ename   mgr     mgr_n   mgr_n_1 mgr_n_2
7369	SMITH	7902	7902	7902	7902
7499	ALLEN	7698	7698	7698	7698
7521	WARD	7698	7698	7698	7698
7566	JONES	7839	7839	7839	7839
7654	MARTIN	7698	7698	7698	7698
7698	BLAKE	7839	7839	7839	7839
7782	CLARK	7839	7839	7839	7839
7788	SCOTT	7566	7566	7566	7566
7839	KING	null    9999	9999	9999
7844	TURNER	7698	7698	7698	7698
7876	ADAMS	7788	7788	7788	7788
7900	JAMES	7698	7698	7698	7698
7902	FORD	7566	7566	7566	7566
7934	MILLER	7782	7782	7782	7782
SELECT empno, ename, mgr, 
       NVL(mgr, 9999) mgr_n, 
       NVL2(mgr, mgr, 9999) mgr_n_1, 
       COALESCE(mgr, 9999, 9999, 9999) mgr_n_2 
FROM emp;

--users ���̺��� ������ ���������� ��ȸ�ǵ��� ���� �ۼ� reg_dt�� null�� ��� SYSDATE ����
SELECT userid, usernm, reg_dt,
       NVL(reg_dt, SYSDATE) n_reg_dt
FROM users
WHERE userid NOT IN('brown');

SELECT userid, usernm, reg_dt,
       NVL2(reg_dt, reg_dt, SYSDATE) n_reg_dt
FROM users
WHERE userid NOT IN('brown');

SELECT userid, usernm, reg_dt,
       COALESCE(reg_dt, SYSDATE) n_reg_dt
FROM users
WHERE userid NOT IN('brown');

--condition
--case
--emp���̺� job �÷� ��������
--job�� 'SALESMAN'�̸� sal * 1.05�� ������ �� ����
--job�� 'MANAGER'�̸� sal * 1.10�� ������ �� ����
--job�� 'PRESIDENT'�̸� sal * 1.20�� ������ �� ����
--�� 3���� ������ �ƴҰ�� sal �� ����
--empno, ename, job, sal, ���������� �޿� ALIAS = bonus
SELECT empno, ename, job, sal,
       CASE
            WHEN job = 'SALESMAN' THEN sal * 1.05
            WHEN job = 'MANAGER' THEN sal * 1.10
            WHEN job = 'PRESIDENT' THEN sal * 1.20
            ELSE sal
       END bonus,
       comm, --NULLó�� �Լ� ������� �ʰ� CASE ���� �̿��Ͽ� 
             --comm�� NULL�� ��� -10�� �����ϵ��� ����
        CASE
             WHEN comm IS NULL THEN - 10
             ELSE comm
             
        END bonus1            
FROM emp;

--DECODE
SELECT empno, ename, job, sal,
       DECODE(job, 'SALESMAN', sal*1.05, 'MANAGER', sal*1.10, 'PRESIDENT', sal*1.20, sal) bonus
            --job�� 'SALESMAN'�̸� sal * 1.05 'MANAGER'�̸� sal*1.10 'PRESIDENT'�̸� sal*120 �׷��������� sal
FROM emp;