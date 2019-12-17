-- WITH
-- WITH ����̸� AS (
--    ��������
-- )
--SELECT *
--FROM ����̸�

-- deptno, avg(sal) avg_sal
-- �� �ش�μ��� �޿������ ��ü ������ �޿� ��պ��� ���� �μ��� ���� ��ȸ
SELECT deptno, avg(sal) avg_sal
FROM emp
GROUP BY deptno
HAVING avg(sal) > ( SELECT avg(sal) FROM emp);

--WITH ���� ����Ͽ� ���� ������ �ۼ�
WITH dept_sal_avg AS(
    SELECT deptno, avg(sal) avg_sal
    FROM emp
    GROUP BY deptno),
    emp_sal_avg AS(
    SELECT avg(sal) avg_sal
    FROM emp)
SELECT *
FROM dept_sal_avg
WHERE dept_sal_avg.avg_sal > (SELECT avg_sal FROM emp_sal_avg);

--��������
--�޷¸����
--CONNECT BY LEVEL <= N
--���̺��� ROW �Ǽ��� N��ŭ �ݺ��Ѵ�
--CONNECT BY LEVEL ���� ����� ����������
--SELECT ������ LEVEL �̶�� Ư�� �÷��� ����� �� �ִ�
--������ ǥ���ϴ� Ư�� �÷����� 1���� �����ϸ� ROWNUM�� ����������
--���߿� ���Ե� START WITH, CONNECT BY ������ �ٸ� ���� ���� �ȴ�.

--2019�� 11���� 30�ϱ��� ����
--���� + ���� = ������ŭ �̷��� ����
--201911 -- > �ش����� ��¥�� ���ϱ��� ���� �ϴ°�?
--1.�� 2.��....7.��
 --�Ͽ����̸� ��¥, ȭ�����̸� ��¥, �������̸� ��¥
SELECT /*dt,d,*/iw,
       MAX(DECODE(d, 1, dt))��, MAX(DECODE(d, 2, dt))��, MAX(DECODE(d, 3, dt))ȭ,
       MAX(DECODE(d, 4, dt))��, MAX(DECODE(d, 5, dt))��, MAX(DECODE(d, 6, dt))��,
       MAX(DECODE(d, 7, dt))��
FROM
(SELECT TO_DATE(:yyyymm,' yyyymm')+ (LEVEL -1) dt,
       TO_CHAR(TO_DATE(:yyyymm,' yyyymm')+ (LEVEL -1),'d') d,
       TO_CHAR(TO_DATE(:yyyymm,' yyyymm')+ (LEVEL ),'iw') iw
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'yyyymm')),'dd'))
GROUP BY iw
ORDER BY iw;



SELECT /*dt,d,*/iw,
       DECODE(d, 1, dt)��, DECODE(d, 2, dt), DECODE(d, 3, dt)ȭ,
       DECODE(d, 4, dt)��, DECODE(d, 5, dt), DECODE(d, 6, dt)��,
       DECODE(d, 7, dt)��
FROM
(SELECT TO_DATE(:yyyymm,' yyyymm')+ (LEVEL -1) dt,
       TO_CHAR(TO_DATE(:yyyymm,' yyyymm')+ (LEVEL -1),'d') d,
       TO_CHAR(TO_DATE(:yyyymm,' yyyymm')+ (LEVEL ),'iw') iw
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'yyyymm')),'dd'));


SELECT /*dt,d,*/ dt -(d-1),
      
       MAX(DECODE(d, 1, dt))��, MAX(DECODE(d, 2, dt))��, MAX(DECODE(d, 3, dt))ȭ,
       MAX(DECODE(d, 4, dt))��, MAX(DECODE(d, 5, dt))��, MAX(DECODE(d, 6, dt))��,
       MAX(DECODE(d, 7, dt))��
FROM
(SELECT TO_DATE(:yyyymm,' yyyymm')+ (LEVEL -1) dt,
       TO_CHAR(TO_DATE(:yyyymm,' yyyymm')+ (LEVEL -1),'d') d,
       TO_CHAR(TO_DATE(:yyyymm,' yyyymm')+ (LEVEL ),'iw') iw
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'yyyymm')),'dd') + TO_CHAR(TO_DATE(:yyyymm,' yyyymm')+ (LEVEL -1),'d'))
GROUP BY dt -(d-1)
ORDER BY dt -(d-1);








SELECT /*dt,d,*/iw,
       MAX(DECODE(d, 1, dt))��, MAX(DECODE(d, 2, dt))��, MAX(DECODE(d, 3, dt))ȭ,
       MAX(DECODE(d, 4, dt))��, MAX(DECODE(d, 5, dt))��, MAX(DECODE(d, 6, dt))��,
       MAX(DECODE(d, 7, dt))��
FROM
(SELECT TO_DATE(:yyyymm,' yyyymm')+ (LEVEL -1) dt,
       TO_CHAR(TO_DATE(:yyyymm,' yyyymm')+ (LEVEL -1),'d') d,
       TO_CHAR(TO_DATE(:yyyymm,' yyyymm')+ (LEVEL ),'iw') iw
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'yyyymm')),'dd'))
GROUP BY iw
ORDER BY ��;


SELECT nvl(MIN(DECODE(mm,1,sales_sum)),0)jan,
       nvl(MIN(DECODE(mm,2,sales_sum)),0)feb,
       nvl(MIN(DECODE(mm,3,sales_sum)),0)mar,
       nvl(MIN(DECODE(mm,4,sales_sum)),0)api,
       nvl(MIN(DECODE(mm,5,sales_sum)),0)may,
       nvl(MIN(DECODE(mm,6,sales_sum)),0)june       
FROM
(SELECT TO_CHAR(dt,'mm') mm, sum(sales) sales_sum
FROM sales
GROUP BY TO_CHAR(dt,'mm'));


SELECT MIN(DECODE(mm,1,sum_sales)),
       MIN(DECODE(mm,2,sum_sales)),
       MIN(DECODE(mm,3,sum_sales)),
       MIN(DECODE(mm,4,sum_sales)),
       MIN(DECODE(mm,5,sum_sales)),
       MIN(DECODE(mm,6,sum_sales))
FROM
(SELECT TO_CHAR(dt,'mm')mm,sum(sales)sum_sales
FROM sales
GROUP BY TO_CHAR(dt,'mm'));

SELECT dept_h.*, LEVEL
FROM dept_h
START WITH deptcd='dept0' -- �������� deptcd = 'dept0' --> XXȸ��(�ֻ�������)
CONNECT BY PRIOR deptcd = p_deptcd --PRIOR : �̹� ������
ORDER BY level;

/*
    dept0(XXȸ��)
        dept0_00(�����κ�)
            dept0_00_0(��������)
        dept0_01(������ȹ��)
            dept0_01_0(��ȹ��)
                dept0_00_0_0(��ȹ��Ʈ)
        dept0_02(�����ý��ۺ�)
            dept0_02_0(����1��)
            dept0_02_1(����2��)





