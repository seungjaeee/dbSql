--emp, dept���̺��� �̿��Ͽ� ������ ���� ��ȸ�ǵ��� ������ �ۼ��ϼ���( �޿� 2500 �ʰ�, ����� 7600���� ū ����)
SELECT empno, ename, sal, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND sal > 2500
AND empno > 7600;

--ANSI SQL
SELECT empno, ename, sal, emp.deptno, dname
FROM emp JOIN dept ON emp.deptno = dept.deptno
AND sal > 2500 
AND empno > 7600;

SELECT *
FROM prod;

SELECT *
FROM lprod;

--prod �� lprod ���̺� ����
SELECT lprod_gu, lprod_nm, prod_id, prod_name
FROM prod, lprod
WHERE prod_lgu = lprod_gu;

--prod �� buyer ���̺� ����
SELECT buyer_id, buyer_name, prod_id, prod_name
FROM prod, buyer
WHERE prod_buyer = buyer_id;


SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member, cart, prod
WHERE mem_id = cart_member
AND cart_prod = prod_id;


--join �ǽ� 4
SELECT cycle.cid, cnm, pid, day, cnt
FROM customer, cycle
WHERE customer.cid = cycle.cid
AND cnm IN ('brown', 'sally');

--join �ǽ� 5
SELECT cycle.cid,  product.pid, cnm, pnm, day, cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
AND cycle.pid = product.pid
AND cnm IN('brown', 'sally');

--join �ǽ� 6
SELECT cycle.cid, cnm, product.pid, pnm, SUM(cnt) cnt                
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
AND cycle.pid = product.pid
GROUP BY cycle.cid,cnm,product.pid,pnm;

--join �ǽ� 7
SELECT cycle.pid, pnm, SUM(cnt) cnt
FROM cycle, product
WHERE cycle.pid = product.pid
GROUP BY cycle.pid, pnm ;

--SELECT * 
--FROM DBA_USERS;
--
--ALTER USER HR ACCOUNT UNLOCK; --���̵� ��� ����
--
--ALTER USER HR IDENTIFIED BY xxxx; --��й�ȣ����

SELECT region_id,

