--OUTER join : ���� ���ῡ ���� �ϴ��� ������ �Ǵ� ���̺��� �����ʹ�
-- �������� �ϴ� join
--LEFT OUTER join : ���̺�1 LEFT OUTER JOIN ���̺�2
--���̺�1�� ���̺�2�� �����Ҷ� ���ο� �����ϴ��� ���̺�1���� �����ʹ� ��ȸ�� �ǵ��� �Ѵ�.
--���ο� ������ �࿡�� ���̺�2�� �÷����� �������� �����Ƿ� NULL�� ǥ�õȴ�.
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m 
            ON (e.mgr = m.empno);

--�׳� ����
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e JOIN emp m 
            ON (e.mgr = m.empno);

--
SELECT e.empno, e.ename, m.empno, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m 
            ON (e.mgr = m.empno AND m.deptno = 10);
            
SELECT e.empno, e.ename, m.empno, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m 
            ON (e.mgr = m.empno )
WHERE m.deptno = 10;

--ORACLE SQL�� outer join
--�Ϲ����ΰ� �������� �÷��� (+) ǥ��
--(+)ǥ�� : �����Ͱ� �������� �ʴµ� ���;� �ϴ� ���̺��� �÷�
-- ���� LEFT OUTER JOIN �Ŵ���
--  ON(����tb.�Ŵ�����ȣ = �Ŵ���tb.������ȣ)
-- ORACLE OUTER������
-- WHERE ����tb.�Ŵ�����ȣ = �Ŵ���tb.������ȣ(+) -- �Ŵ����� �����Ͱ� �������� ����

--ANSI
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m 
            ON (e.mgr = m.empno);
            
--ORACLE
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m 
WHERE e.mgr = m.empno(+);

--�Ŵ��� �μ���ȣ ����
--ANSI SQL - WHERE���� ����� ����
-- --> OUTER ������ ������� ���� ��Ȳ
-- �ƿ��� ������ ����Ǿ�� �ϴ� ���̺� ��� �÷��� (+)�� �پ�� �ȴ�.
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m 
WHERE e.mgr = m.empno(+)
AND m.deptno(+) = 10;

--ANSI sql�� on���� ����� ���� ����
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m 
WHERE e.mgr = m.empno(+)
AND m.deptno(+) = 10;
           
--emp ���̺��� 14���� ������ �ְ� 14���� 10, 20 , 30 �μ��߿� �� �μ��� ���Ѵ�.
-- ������ dept���̺��� 10,20,30,40�� �μ��� ����
--�μ���ȣ, �μ��� ,�ش�μ��� ���� �������� �������� ����
--�μ���ȣ, �μ���, �ش�μ��� ���� �������� �������� ������ �ۼ�
/*
10 ACCOUNTING 3 
20 RESEARCH   5
30 SALES      6
40 OPERATION  0
*/

SELECT dept.deptno, dept.dname, COUNT(emp.deptno) cnt
FROM emp, dept
WHERE emp.deptno(+) = dept.deptno
GROUP BY dept.deptno, dept.dname;

-- dept : deptno, dname
-- inline : dpetno, cnt(������ ��)
SELECT dept.deptno, dept.dname, NVL(emp_cnt.cnt, 0) cnt
FROM
dept,
(SELECT deptno, COUNT(*) cnt
FROM emp
GROUP BY deptno) emp_cnt
WHERE dept.deptno = emp_cnt.deptno(+);

--ANSI 
SELECT dept.deptno, dept.dname, NVL(emp_cnt.cnt, 0) cnt
FROM
dept LEFT OUTER JOIN (SELECT deptno, COUNT(*) cnt
                      FROM emp 
                      GROUP BY deptno) emp_cnt 
                      ON(dept.deptno = emp_cnt.deptno);
                     
               
               
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m 
            ON (e.mgr = m.empno);

--RIGHT OUTER JOIN            
SELECT e.empno, e.ename, m.empno, m.ename  --RIGHT�� �����̵Ǵ� ���̺� �̿����ʿ���
FROM emp e RIGHT OUTER JOIN emp m 
            ON (e.mgr = m.empno);

--FULL OUTER : LEFT OUTER + RIGHT OUTER -> �ߺ������� �ѰǸ� �����
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e FULL OUTER JOIN emp m 
            ON (e.mgr = m.empno);

--OUTER JOIN 1
SELECT a.buy_date, a.buy_prod, prod.prod_id, prod.prod_name, a.buy_qty
FROM buyprod a, prod
WHERE a.buy_prod(+) = prod.prod_id
AND a.buy_date (+) = '20050125';

--OUTER JOIN 2
SELECT nvl(TO_CHAR(a.buy_date, 'yy/mm/dd'), '05/01/25') , a.buy_prod, prod.prod_id, prod.prod_name, a.buy_qty
FROM buyprod a, prod
WHERE a.buy_prod(+) = prod.prod_id
AND a.buy_date (+) = '20050125';


--OUTER JOIN 3
SELECT nvl(TO_CHAR(a.buy_date, 'yyyy/mm/dd'), '2005/01/25') , a.buy_prod, prod.prod_id, prod.prod_name, nvl(a.buy_qty, 0) 
FROM buyprod a, prod
WHERE a.buy_prod(+) = prod.prod_id
AND a.buy_date (+) = '20050125';

SELECT *
FROM cycle;
SELECT *
FROM product;

--OUTER JOIN 4
SELECT product.pid, product.pnm, nvl(cycle.cid,0)cid, nvl(cycle.day, 0) day, nvl(cycle.cnt,0) cnt
FROM cycle, product
WHERE product.pid = cycle.pid(+)
AND cycle.cid(+) = '1';

SELECT product.pid, product.pnm, nvl(cycle.cid,0)cid, nvl(cycle.day, 0) day, nvl(cycle.cnt,0) cnt
FROM cycle RIGHT OUTER JOIN product ON product.pid = cycle.pid
AND cycle.cid = '1';

--OUTER JOIN 5
SELECT product.pid, product.pnm, nvl(cycle.cid,1)cid, customer.cnm, nvl(cycle.day, 0) day, nvl(cycle.cnt,0) cnt
FROM cycle, product, customer
WHERE product.pid = cycle.pid(+)
AND cycle.cid(+) = '1'
AND customer.cnm IN ('brown');












SELECT *
FROM customer;
SELECT *
FROM cycle;
SELECT * 
FROM product;