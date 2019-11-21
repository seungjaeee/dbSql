-- Ư�� ���̺��� �÷� ��ȸ
--1. DESC ���̺��
--2. SELECT * FROM user_tab_columns;

--prod ���̺��� �÷���ȸ
DESC prod;

VARCHAR2, CHAR --> ���ڿ� (Character)
NUMBER --> ����
CLOB --> Character Large OBject, ���ڿ� Ÿ���� ���� ����
        --�ִ� ������ : VARCHAR2(4000), CLOB : 4GB
DATE --> ��¥(�Ͻ� = ��,��,�� + �ð�, ��, ��)
--date Ÿ�Կ� ���� ������ �����?
'2019/11/20 09:16:20' + 1 = ??

--USERS ���̺��� ��� �÷��� ��ȸ �غ�����

SELECT *
FROM users; --��� �÷� ��ȸ

--userid, usernm, reg_dt ������ �÷��� ��ȸ
--������ ���� ���ο� �÷��� ���� (reg_dt�� ���� ������ �� ���ο� ���� �÷�)
--��¥ + ���� ������ ?? ==> ���ڸ� ���� ��¥Ÿ���� ����� ���´� reg_dt �� 19/02/05 �϶� reg_dt+5�� 19/02/10 ��.(5���� ������)
--��Ī : ���� �÷����̳� ������ ���� ������ ���� �÷��� ������ �÷��̸��� �ο�
--      col | express [AS] ��Ī��
SELECT userid, usernm, reg_dt reg_date, reg_dt+5 AS after5day
FROM users;

--���� ���, ���ڿ� ��� ( oracle : ' ' , java ������ '', "")
--table�� ���� ���� ���Ƿ� �÷����� ����
--���ڿ� ���� ���� ( +, -, /, *)
--���ڿ� ���� ���� ( +���簡 ���� ����, ==>||)
SELECT '����'userid, usernm, reg_dt
FROM users;

SELECT (10-5)*5, 'DB SQL ����', userid, '_modified', usernm, reg_dt
FROM users;

SELECT 'DB SQL ����', 
usernm || '_modified', reg_dt
-- userid + '_modified', ���ڿ� ������ ���ϱ� ������ ����
FROM users;

--NULL : ���� �𸣴� ��
--NULL�� ���� ���� ����� �׻� NULL �̴�
--DESC ���̺�� : NOT NULL�� �����Ǿ��ִ� �÷����� ���� �ݵ�� ���� �Ѵ�

--users ���ʿ��� ������ ����
SELECT *
FROM users;

DELETE users
WHERE userid NOT IN ('brown', 'sally', 'cony', 'moon', 'james');

rollback;

commit;

SELECT userid, usernm, reg_dt
FROM users;

--null������ �����غ��� ���� moon�� reg_dt �÷��� null�� ���� ��
UPDATE users SET reg_dt = NULL
WHERE userid = 'moon';

rollback;
commit;

--users ���̺��� reg_dt �÷����� 5���� ���� ���ο� �÷��� ���� �� ( moon�� null�̱� ������ 5���� ���ص� ���� null �̴� )
SELECT userid, usernm, reg_dt + 5
FROM users;

SELECT prod_id id, prod_name name
FROM prod;

SELECT lprod_gu gu, lprod_nm nm
FROM lprod;

SELECT buyer_id ���̾���̵� , buyer_name �̸� 
FROM buyer;

--���ڿ� �÷��� ����    (�÷� || �÷�, '���ڿ����' || �÷�)
--                    ( CONCAT(�÷�, �÷�) )
SELECT *
FROM users;

SELECT userid, usernm,
        --userid || usernm AS id_nm,
        CONCAT(userid, usernm) con_id_nm
        -- ||�� �̿��ؼ� userid, usernm, pass
        --userid || usernm || pass id_nm_pass
        -- CONCAT�� �̿��ؼ� userid, usernm, pass
       -- CONCAT (userid, usernm) CONCAT (pass) con_id_nm_pass
FROM users;

SELECT userid, usernm, pass,
        userid || usernm || pass id_nm_pass
FROM users;

SELECT userid, usernm,
        CONCAT (CONCAT(userid, usernm), pass) con_id_nm_pass
FROM users;

--����ڰ� ���������̺� ��� ��ȸ
SELECT table_name
FROM user_tables;

--LPROD --> SELECT * FROM LPROD;
SELECT ' SELECT * FROM ' || table_name -- <- ' SELECT * ' || table_name �� query��� ��Ī���� �ٲ��� AS�� ����������
                
FROM user_tables;

        --CONCAT�Լ��� �̿��ؼ�
        --1. 'SELECT * FROM '
        --2. table_name
        --3. ';'
        -- CONCAT(CONCAT('SELECT * FROM ' , table_name ), ';')
SELECT 'SELECT * FROM ', table_name, ';',
        CONCAT (CONCAT (' SELECT * FROM ', table_name), ';')
FROM user_tables;
        


SELECT * FROM buyer;
SELECT * FROM BUYPROD;
SELECT * FROM CART;
SELECT * FROM LPROD;
SELECT * FROM member;
SELECT * FROM no_exists_table;
SELECT * FROM prod;
SELECT usernm, userid FROM users;

-- WHERE :������ ��ġ�ϴ� �ุ ��ȸ�ϱ����� ���
--        �࿡ ���� ��ȸ ������ �ۼ�
-- WHERE ���� ������ �ش� ���̺��� ��� �࿡ ���� ��ȸ
SELECT userid, usernm, alias, reg_dt
FROM users;

SELECT userid, usernm, alias, reg_dt
FROM users
WHERE userid = 'brown'; --userid �÷��� 'brown'�� ��(row)�� ��ȸ

--emp���̺��� ��ü ������ ��ȸ (��� ��(row), ��(column))
SELECT *
FROM emp;

SELECT *
FROM dept;

--�μ���ȣ(deptno)�� 20���� ũ�ų� ���� �μ����� ���ϴ� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE deptno >= 20;

--�����ȣ(empno)�� 7700���� ũ�ų� ���� ����� ������ ��ȸ
SELECT *
FROM emp
WHERE empno >= 7700;

--����Ի�����(hiredate)�� 1982�� 1�� 1�� ������ ��� ���� ��ȸ
-- ���ڿ��� --> ��¥ Ÿ������ ���� TO_DATE('��¥���ڿ�', '��¥���ڿ�����')
-- �ѱ� ��¥ ǥ�� : ��-��-��
-- �̱� ��¥ ǥ�� : ��-��-�� (01-01-2020)
SELECT empno, ename, hiredate,
       2000 no, '���ڿ����' str, TO_DATE('19810101', 'yyyymmdd')
FROM emp
WHERE hiredate >= TO_DATE('19820101', 'yyyymmdd');

--���� ��ȸ (BETWEEN ���۱��� AND �������) (BETWEEN A and B )
--���۱���, ��������� ����
--����߿��� �޿�(sal)�� 1000���� ũ�ų� ����, 2000���� �۰ų� ���� ��� ������ȸ
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

--BETWEEN AND �����ڴ� �ε�ȣ �����ڷ� ��ü ����
SELECT *
FROM emp
WHERE sal >= 1000 
AND   sal <= 2000;

--emp ���̺��� �Ի� ���ڰ� 1982��1��1�� ���ĺ��� 1983��1��1�� ������ ����� ename, hiredate �����͸� ��ȸ�ϴ� ������ �ۼ��Ͻÿ� ( ������ between ���)
SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE('19820101', 'yyyymmdd') AND
                       TO_DATE('19830101', 'yyyymmdd');
                       
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE ('19820101', 'yyyymmdd')
AND   hiredate <= TO_DATE ('19830101', 'yyyymmdd');
