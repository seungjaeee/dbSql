INSERT INTO dept_test VALUES(99,'','');

--PL/SQL pt 18 procedure ���� �ǽ�3��
CREATE OR REPLACE PROCEDURE UPDATEdept_test
( p_deptno IN dept_test.deptno%TYPE,
  p_dname IN dept_test.dname%TYPE,
  p_loc IN dept_test.loc%TYPE)
IS
 deptno dept_test.deptno%TYPE;
 dname dept_test.dname%TYPE;
 loc dept_test.loc%TYPE;
BEGIN
    UPDATE dept_test SET deptno = 99, dname = 'ddit_m', loc = 'daejeon'
    WHERE deptno = 99;
    commit;
    DBMS_OUTPUT.PUT_LINE(deptno || dname || loc);
END;
/
exec UPDATEdept_test(99,'ddit_m','daejeon_');

SELECT *
FROM dept_test;

--ROWTYPE
--Ư�� ���̺��� ROW ������ ���� �� �ִ� ���� Ÿ��
--TYPE : ���̺��.���̺��÷���%TYPE

SET SERVEROUTPUT ON;
DECLARE
    --dept ���̺��� row ������ ���� �� �ִ� ROWTYPE ��������
    dept_row dept%ROWTYPE;
BEGIN
    SELECT *
    INTO dept_row
    FROM dept
    WHERE deptno = 10;
    
    dbms_OUTPUT.PUT_LINE(dept_row.dname ||', ' || dept_row.loc);
END;
/

--RECORD TYPE : �����ڰ� �÷��� ���� �����Ͽ� ���߿� �ʿ��� TYPE�� ����
--TYPE Ÿ���̸� IS RECORD(
--      �÷�1 �÷�1TYPE,
--      �÷�1 �÷�2TYPE
-- );
--public class Ŭ������{
--        �ʵ�type �ʵ�(�÷�) ; //String name;
--        �ʵ�2type �ʵ�(�÷�)2 ; //int age;
-- }
DECLARE
    --�μ��̸�, loc ������ ������ �� �ִ� RECORE TYPE ����
    TYPE dept_row IS RECORD(
        dname dept.dname%TYPE,
        loc dept.loc%TYPE);
    --TYPE������ �Ϸ��, type�� ���� ������ ����
    -- java : Class ������ �ش� class�� �ν��Ͻ��� ����(new)
    --PL SQL : �����̸� ����Ÿ�� dname dept.dname%TYPE;
    dept_row_data dept_row;
BEGIN
    SELECT dname, loc
    INTO dept_row_data
    FROM dept
    WHERE deptno = 10;
    dbms_OUTPUT.PUT_LINE( dept_row_data.dname || ', ' || dept_row_data.loc);
END;
/

--PL SQL������ index�� ���ڰ��ƴ϶� ���ڿ��� ����
-- arr['�̸�'] = "brown";
-- arr['����'] = "12��";

--TABLE TYPE : �������� ROWTYPE�� ������ �� �ִ� TYPE
-- col --> row --> table
-- TYPE ���̺�Ÿ�Ը� IS TABLE OF ROWTYPE/RECORD INDEX BY �ε��� Ÿ��(BINARY_INTEGER)
--�ڹٿ� �ٸ��� PLSQL������ array ������ �ϴ� table type�� �ε�����
--���� �Ӹ� �ƴ϶� ���ڿ� ���µ� �����ϴ�
--�׷��� ������ index�� ���� Ÿ���� ����Ѵ�
--�Ϲ������� array(list) ������ ����� INDEX BY BINARY_INTEGER
--arr(1).name = 'brown'
--arr('person').name = 'brown'

--dept ���̺��� row�� ������ ���� �� �� �ִ� dept_tab TABLE TYPE �����Ͽ�
--SELECT * FROM dept;�� ���(������)�� ������ ��´�
DECLARE
    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
    v_dept dept_tab;
BEGIN
    --�� row�� ���� ������ ������ �� : INTO
    --���� row�� ���� ������ ���� : BULK COLLECT INTO
    SELECT *
    BULK COLLECT INTO v_dept
    FROM dept;
    
    FOR i IN 1..v_dept.count LOOP
        --arr[1]
    DBMS_OUTPUT.PUT_LINE(v_dept(i).deptno);
    END LOOP;
END;
/


--���� ���� IF
-- IF condition THEN
--    statement
-- ELSIF condition THEN
--    statement
--ELSE
--    statement
--END IF;

--PL/SQL IF �ǽ�
-- ���� p (NUMBER)�� 2��� ���� �Ҵ��ϰ�
-- IF ������ ���� p�� ���� 1, 2, �� ���� ���϶� �ؽ�Ʈ ���

DECLARE
    p NUMBER := 2;    --���� ����� �Ҵ��� �ѹ��忡�� ����
BEGIN
    --p := 2;
    IF p = 1 THEN
        DBMS_OUTPUT.PUT_LINE('P=1');
    ELSIF p = 2 THEN    --java �� ������ �ٸ��� (else if -> ELSIF)
        DBMS_OUTPUT.PUT_LINE('p=2');
    ELSE
        DBMS_OUTPUT.PUT_LINE(p);
    END IF;
END;
/

-- FOR LOOP
-- FOR �ε������� IN [REVERS] START..END LOOP
--      �ݺ����๮
-- END LOOP;
-- 0~5���� ���� ������ �̿��Ͽ� �ݺ��� ����
DECLARE
BEGIN
    FOR i IN 0..5 LOOP
        DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;
END;
/

-- 1~10 : 55
-- 1~10 ������ ���� LOOP�� �̿��Ͽ� ���, ����� s_val �̶�� ������ ���
-- DBMS_OUTPUT.PUT_LINE �Լ��� ���� ȭ�鿡 ���
DECLARE
    s_val NUMBER := 0;
BEGIN
    FOR i IN 1..10 LOOP    
    s_val := s_val+i;        
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(s_val);
END;
/

-- while loop
-- WHILE condition LOOP
--   statement
-- END LOOP;
-- 0���� 5���� WHILE ���� �̿��Ͽ� ���
DECLARE
 i NUMBER :=0;
BEGIN
    WHILE i <= 5 LOOP
    DBMS_OUTPUT.PUT_LINE(i);
    i := i + 1;
    
END LOOP;
END;
/

--LOOP
--LOOP
--  statement;
-- EXIT [WHEN condition];
-- END LOOP;
DECLARE
    i NUMBER := 0;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(i);
        EXIT WHEN i >= 5;
        i := i + 1;
    END LOOP;
END;
/

-- CURSOR : SQL�� �����ڰ� ������ �� �ִ� ��ü
-- ������ : �����ڰ� ������ Ŀ������ ������� ���� ����, ORACLE���� �ڵ�����
--         OPEN, ����, FETCH, CLOSE�� �����Ѵ�
-- ����� : �����ڰ� �̸��� ���� Ŀ��. �����ڰ� ���� �����ϸ�
--         ����, OPEN, FETCH, CLOSE �ܰ谡 ����
--  CURSOR Ŀ���̸� IS -- Ŀ�� ����
--      QUERY;
--  OPEN Ŀ���̸�; -- Ŀ�� OPEN
-- FETCH Ŀ���̸� INTO ����1, ����2....     --Ŀ�� FETCH(�� ����)
--CLOSE Ŀ���̸�, --Ŀ�� CLOSE

--�μ����̺��� ��� ���� �μ��̸�, ��ġ ���� ������ ��� (CURSOR)�� �̿�)
DECLARE
    --Ŀ�� ����
    CURSOR dept_cursor IS
    SELECT dname,loc
    FROM dept;
    v_dname dept.dname%TYPE;
    v_loc dept.loc%TYPE;
BEGIN
    --Ŀ�� ����
    OPEN dept_cursor;
    LOOP
    FETCH dept_cursor INTO v_dname, v_loc;
    EXIT WHEN dept_cursor%NOTFOUND;
    dbms_output.put_line(v_dname || ', ' || v_loc);
    --�������� : FETCH �� �����Ͱ� ���� �� ����
    
    END LOOP;
    CLOSE dept_cursor;
    
    
END;
/













