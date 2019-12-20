SELECT *
FROM dept, emp
WHERE dept.deptno = emp.deptno;
--dept ���� �д� ����
-- join �÷��� hash �Լ��� ������ �ش� �ؽ��Լ��� �ش��ϴ� bucket�� �����͸� �ִ´�
-- 10 --> ccc1122 (hashvalue)

--emp ���̺� ���� ���� ������ �����ϰ� ����
-- 10 --> ccc1122 (hashvalue)


-- �����ȣ, ����̸�, �μ���ȣ, �޿�, �μ����� ��ü �޿���
SELECT empno, ename, deptno, sal, 
        SUM(sal) OVER(ORDER BY sal 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum, -- ���� ó������ ���� �����
        --�ٷ� �������̶� ����������� �޿� ��
        SUM(sal) OVER(ORDER BY sal
        ROWS BETWEEN 1 PRECEDING AND CURRENT ROW)c_sum2
FROM emp;

--���� SQL PT 127
SELECT empno, ename, deptno,sal,
    SUM(sal) OVER(PARTITION BY deptno ORDER BY sal,empno
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp;

--ROWS �� RANGE ���� Ȯ���ϱ�
SELECT empno, ename, deptno, sal,
    SUM(sal) OVER(ORDER BY sal ROWS UNBOUNDED PRECEDING) row_sum,
    SUM(sal) OVER(ORDER BY sal RANGE UNBOUNDED PRECEDING) range_sum,
    SUM(sal) OVER(ORDER BY sal) c_sum
FROM emp;

--PL/SQL
--PL/SQL �⺻����
--DECLARE : �����, ������ �����ϴ� �κ�
--BEGIN : PL/SQL�� ������ ���� �κ�
--EXCEPTION : ����ó����

SET SERVEROUTPUT ON; -- DBMS_OUTPUT.PUT_LINE �Լ��� ����ϴ� ����� ȭ�鿡 �����ֵ��� Ȱ��ȭ
DECLARE -- �����
    --java : Ÿ�� ������;
    --pl/sql : ������ Ÿ��;
--    v_dname VARCHAR2(14);
--    v_loc VARCHAR2(13);
    --���̺� �÷��� ���Ǹ� �����Ͽ� ������ Ÿ���� �����Ѵ�
    v_dname dept.dname %TYPE;
    v_loc dept.loc %TYPE;
BEGIN
    --DEPT ���̺��� 10�� �μ��� �μ��̸�,loc ������ ��ȸ
    SELECT dname,loc
    INTO v_dname,v_loc--����1,����2
    FROM dept
    WHERE deptno = 10;
    
    -- String a = "t";
    -- String b = "c";
    --System.out.println(a + b);
    dbms_OUTPUT.PUT_LINE(v_dname || v_loc);
END;
/ 
-- PL/SQL ����� ���� �϶�� �� /�������� ���� ���� �ȵ�.


--10�� �μ��� �μ��̸�, ��ġ������ ��ȸ�ؼ� ������ ���
--������ DBMS_OUTPUT.PUT_LINE�Լ��� �̿��Ͽ� console�� ���
CREATE OR REPLACE PROCEDURE printdept
--�Ķ���͸� IN/OUT Ÿ��
-- p_�Ķ�����̸� <- �Ķ���� ��� ��
( p_deptno IN dept.deptno %TYPE )
IS
--�����(�ɼ�)
    dname dept.dname %TYPE;
    loc dept.loc %TYPE;
    
--�����
BEGIN
    SELECT dname, loc
    INTO dname, loc
    FROM dept
    WHERE deptno = p_deptno;
    
    DBMS_OUTPUT.PUT_LINE(dname || ' ' || loc);
--����ó��(�ɼ�)
END;
/

exec printdept(40);

CREATE OR REPLACE PROCEDURE printemp
(p_empno IN emp.empno %TYPE)
IS
ename emp.ename %TYPE;
dname dept.dname %TYPE;

BEGIN
    SELECT ename,dname
    INTO ename,dname
    FROM emp,dept
    WHERE empno = p_empno
    AND emp.deptno = dept.deptno;
    
    DBMS_OUTPUT.PUT_LINE(ename || ' ' || dname);
END;
/
exec printemp(7788);

DESC emp;

SELECT ename,dname
   
    FROM emp,dept
    WHERE empno = 7369
    AND emp.deptno = dept.deptno;

SELECT *
FROM emp;

CREATE OR REPLACE PROCEDURE registdept_test
( p_deptno IN dept.deptno %TYPE,
  p_dname IN dept.dname %TYPE,
  p_loc IN dept.loc %TYPE)
  IS
deptno dept.deptno %TYPE;
dname dept.dname %TYPE;
loc dept.loc %TYPE;
BEGIN
    INSERT INTO dept_test VALUES(99,'ddit','daejeon');
    commit;
    DBMS_OUTPUT.PUT_LINE(deptno||dname||loc);
END;
/
exec registdept_test(99,'ddit','daejeon');

SELECT *
FROM dept_test;

DELETE dept_test
WHERE deptno = 99;








