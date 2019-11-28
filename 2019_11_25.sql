SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 10;

SELECT ROWNUM, a.*
FROM
(SELECT ROWNUM rn, empno, ename
FROM emp) a
WHERE rn BETWEEN 11 AND 14;

--emp ���̺��� ename�÷� �������� �������� ���� ������ 11~14��° ���� �����͸� ��ȸ�ϴ� ������ �ۼ��ϼ���
SELECT *
FROM
(SELECT ROWNUM rn, a.*
FROM 
(SELECT empno, ename
FROM emp
ORDER BY ename)a)
WHERE rn BETWEEN 11 AND 14;

SELECT *
FROM
(SELECT ROWNUM rn, a.*
FROM
(SELECT empno, ename
FROM emp
ORDER BY ename)a)
WHERE rn BETWEEN 11 AND 14;

SELECT rn, empno, ename
FROM
(SELECT ROWNUM rn, a.*
FROM
(SELECT empno, ename
FROM emp
ORDER BY ename)a)
WHERE rn BETWEEN 11 AND 14;

-- DUAL ���̺� : sys ������ �ִ� ������ ��밡���� ���̺��̸� 
-- �����ʹ� ���ุ �����ϰ� �÷�(dummy)�� �ϳ� ���� ('X')

SELECT *
FROM dual;

--SINGLE ROW FUNCTION : ��� �ѹ��� FUNCTION�� ����
-- 1���� �� INPUT -> 1���� ������ OUTPUT (COLUMN)
-- 'Hello, World'
--dual ���̺��� �����Ͱ� �ϳ��� �ุ �����Ѵ�. ����� �ϳ��� ������ ���´�
SELECT LOWER('Hello, World') low, UPPER('Hello, World') upper, 
       INITCAP('Hello, World') INIT
FROM dual;

--emp���̺��� �� 14���� ������(����)�� ���� (14���� ��)
--�Ʒ������� ����� 14���� ��
SELECT LOWER('Hello, World') low, UPPER('Hello, World') upper, 
       INITCAP('Hello, World') INIT
FROM emp;

SELECT empno, LOWER (ename) low_enm
FROM emp
WHERE ename = UPPER('smith'); --���� �̸��� smith�� ����� ��ȸ �Ϸ��� �빮��/�ҹ��� ?

SELECT UPPER('smith')
FROM dual;

--���̺� �÷��� �����ص� ������ ����� ���� �� ������
--���̺� �÷� ���ٴ� ������� �����ϴ� ���� �ӵ��鿡�� ����
--�ش� �÷��� �ε����� �����ϴ��� �Լ��� �����ϰԵǸ� ���� �޶����� �Ǿ�
--�ε����� Ȱ�� �� �� ���� �ȴ�
--���� : FBI(Function Based Index)
SELECT empno, LOWER(ename) low_enm
FROM emp
WHERE LOWER(ename) = 'smith'; -- �Ⱦ��°� ����

--HELLO
-- ','
-- HELLO, WORLD (�� 3���� ���ڿ� ����� �̿�, CONCAT �Լ��� ����Ͽ� ���ڿ� ����)
SELECT CONCAT(CONCAT('HELLO', ','), 'WORLD') c1,
       'HELLO' || ',' || 'WORLD' c2,
       --�����ε����� 1����, �����ε����� �����ε��� ���ڿ����� �����Ѵ�. 1�� �����ε��� 5�� �����ε��� 5���� ������.
       SUBSTR('HELLO, WORLD', 1, 5)s1, -- SUBSTR(���ڿ�, �����ε���, �����ε���) 
       --INSTR : ���ڿ��� Ư�� ���ڿ��� �����ϴ���, ������ ��� ������ �ε����� ����
       INSTR('HELLO, WORLD', 'O')i1, -- 5, 9
       --'HELLO, WORLD' ���ڿ��� 6��° �ε��� ���Ŀ� �����ϴ� 'O'���ڿ��� �ε��� ����
       INSTR('HELLO, WORLD', 'O', 6)i2, -- 5,9�߿� 9������ ���ڿ��� Ư�� �ε��� ���ĺ��� �˻��ϵ��� �ɼ�(6��° �ڸ� ���� �˻�)
        INSTR('HELLO, WORLD', 'O', INSTR('HELLO, WORLD', 'O') +1) i3,
       
       --L/RPAD Ư�� ���ڿ��� ����/�����ʿ� ������ ���ڿ� ���̺��� ������ ��ŭ ���ڿ��� ä�� �ִ´�
       LPAD('HELLO, WORLD', 15, '*')L1,
       LPAD('HELLO, WORLD', 15)L2, -- DEFAULT ä�� ���ڴ� �����̴�
       RPAD('HELLO, WORLD', 15, '*')R1,
       
       --REPLACE(����ڿ�, �˻� ���ڿ�, ������ ���ڿ�)
       --����ڿ����� �˻� ���ڿ��� ������ ���ڿ��� ġȯ
       REPLACE('HELLO, WORLD', 'HELLO', 'hello') rep1, --hello, WORLD
       
       --TRIM�� ���ڿ� ��, ���� ������ ����
       '    HELLO, WORLD    ' before_trim,
       TRIM('    HELLO, WORLD    ') after_trim,
       TRIM('H' FROM 'HELLO, WORLD') after_trim2 -- HELLO, WORLD ��� �����κ��� H�� �����ض�.
FROM dept;

--���� �����Լ�
--ROUND : �ݿø� - ROUND(����, �ݿø� �ڸ�)
--TRUNC : ���� - TRUNC(����, ���� �ڸ�)
--MOD : ������ ���� MOD(������, ���� // MOD(5, 2) = 1 

SELECT ROUND(105.54, 1) r1, --��� : 105.5(�ݿø������ �Ҽ��� ���ڸ����� ��������(�Ҽ��� ��°�ڸ����� �ݿø�))
       ROUND(105.55, 1) r2, --��� : 105.6
       ROUND(105.55, 0) r3, --��� : 106 (�Ҽ��� ù��° �ڸ����� �ݿø�) (������ ��)
       ROUND(105.55, -1) r3 --��� : 110( ���� ù��° �ڸ����� �ݿø�)
FROM dual;

SELECT TRUNC(105.54, 1) t1, --���� ����� �Ҽ��� ���ڸ����� ��������(�Ҽ��� ��°�ڸ����� ����) (�ݳ���)
       TRUNC(105.55, 1) t2,
       TRUNC(105.55, 0) t3,
       TRUNC(105.55, -1) t4
FROM dual;

--MOD(������, ����) �������� ������ ���� �������� ��
--MOD(M, 2) �� ��� ���� : 0, 1 (0���� ����-1 ����)
SELECT MOD(5, 2) M1 --����� : 1 (5/2 = ���� 2, [�������� 1])
FROM dual;

--emp ���̺��� sal �÷��� 1000���� �������� ����� ������ ���� ��ȸ �ϴ� sql �ۼ�
--ename, sal, sal/1000 �������� ��, sal/1000 �������� ������
SELECT ename �̸�, TRUNC(sal/1000, 0) ��, MOD(sal, 1000) ������,
       TRUNC(sal/1000, 0) * 1000 + MOD(sal, 1000) �޿�
FROM emp;

--DATE : �����, �ð�, ��, �� 
SELECT ename, hiredate, TO_CHAR(hiredate, 'YYYY-MM-DD hh24-mi-ss') z --YYYY/MM/DD
FROM emp;           -- ���� - ȯ�漳�� - �����ͺ��̽� - NLS ���� ��¥���� ���氡��

--SYSDATE : ������ ���� DATE�� �����ϴ� �����Լ�, Ư���� ���ڰ� ����
--DATE ����  DATE + ����N = N��ŭ ���ڰ���������
--DATE ���꿡 �־ ������ ����
--�Ϸ�� 24�ð�
--DATE Ÿ�Կ� �ð��� ���Ҽ��� �ִ�. 1�ð� = 1/24
SELECT TO_CHAR(SYSDATE + 5, 'YYYY-MM-DD hh24:mi:ss') AFTER5_DAYS, -- 5�� �� ����ð�
       TO_CHAR(SYSDATE + 5/24, 'YYYY-MM-DD hh24:mi:ss') AFTER5_HOURS, -- 5�ð� �� ����ð�
       TO_CHAR(SYSDATE + 5/24/60, 'YYYY-MM-DD hh24:mi:ss') AFTER5_MIN
FROM dual;

SELECT TO_DATE('2019-12-31', 'YYYY-MM-DD') LAST_DAY,
       TO_DATE('2019-12-31', 'YYYY-MM-DD') -5 LAST_DAY_BEFORE5,
       SYSDATE NOW,
       SYSDATE -3 NOW_BEFORE3
FROM dual;

--YYYY, MM, DD, D(������ ���ڷ� -> �Ͽ��� 1, ������ 2, ȭ���� 3 ... ����� 7
--IW(���� 1~53), HH, MI, SS
SELECT TO_CHAR(SYSDATE, 'YYYY') YYYY, -- ���� �⵵
       TO_CHAR(SYSDATE, 'MM') MM, --���� ��
       TO_CHAR(SYSDATE, 'DD') DD, --���� ��
       TO_CHAR(SYSDATE, 'mi') mi, --���� ��
       TO_CHAR(SYSDATE, 'ss') ss, -- ���� ��
       TO_CHAR(SYSDATE, 'D') D, --���� ����(�ְ�����1~7)
       TO_CHAR(SYSDATE, 'IW') IW, --���� ������ ����(�ش����� ������� ������ ��������)
       --2019�� 12�� 31���� �������� �����°�?
       TO_DATE('20191231', 'YYYYMMDD'),
       TO_CHAR(TO_DATE('20191231', 'YYYYMMDD'), 'IW') IW_20191231 -- 1����
FROM dual;

--���ó�¥�� ����� �������� �ۼ�
--���ó�¥�� ����� �ð�-��-��
--���ó�¥�� ����� ��-��-��
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') DT_DASH,
       TO_CHAR(SYSDATE, 'YYYY-MM-DD hh24:mi:ss') dt_dasg_with_time,
       TO_CHAR(SYSDATE, 'DD-MM-YYYY') dt_dd_mm_YYYY
FROM dual;

--DATE Ÿ���� ROUND, TRUNC ����
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD hh24:mi:ss') now,
        --MM���� �ݿø� (11�� -> 1��)
       TO_CHAR(ROUND(SYSDATE, 'YYYY'), 'YYYY-MM-DD hh24:mi:ss') now_YYYY,
       
       --DD���� �ݿø� (25�� -> 1����)
       TO_CHAR(ROUND(SYSDATE, 'MM'), 'YYYY-MM-DD hh24:mi:ss') now_MM,
       --�ð����� �ݿø�
       TO_CHAR(ROUND(SYSDATE, 'DD'), 'YYYY-MM-DD hh24:mi:ss') now_DD
FROM dual;

SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD hh24:mi:ss') now,
        --MM���� ���� (11�� -> 1��)
       TO_CHAR(TRUNC(SYSDATE, 'YYYY'), 'YYYY-MM-DD hh24:mi:ss') now_YYYY,
       
       --DD���� ����
       TO_CHAR(TRUNC(SYSDATE, 'MM'), 'YYYY-MM-DD hh24:mi:ss') now_MM,
       --�ð����� ����
       TO_CHAR(TRUNC(SYSDATE, 'DD'), 'YYYY-MM-DD hh24:mi:ss') now_DD
FROM dual;


--��¥ ���� �Լ�
--MONTHS_BETWEEN(date1, date2) : date2�� date1 ������ ���� ��
--ADD_MONTHS(date, ������ ������) : date���� Ư�� �������� ���ϰų� �� ��¥
--NEXT_DAY(date, weekday(1~7)) : date���� ù��° weekday ��¥
--LAST_DAY(date) : date�� ���� ���� ������ ��¥

--MONTHS_BETWEEN(date1, date2)
SELECT MONTHS_BETWEEN(TO_DATE('2019-11-25', 'yyyy-mm-dd'),  
                      TO_DATE('2019-03-31', 'yyyy-mm-dd')) m_bet,
        TO_DATE('2019-11-25', 'yyyy-mm-dd') -  TO_DATE('2019-03-31', 'yyyy-mm-dd') d_m --�� ��¥ ������ ���� ��
FROM dual;

--�ڡڡ�ADD_MONTHS(date, number(+,-) )�ڡڡ�
SELECT ADD_MONTHS (TO_DATE('20191125', 'yyyymmdd'), 5) NOW_AFTER5M,
       ADD_MONTHS (TO_DATE('20191125', 'yyyymmdd'), -5) NOW_BEFORE5M,
       SYSDATE + 100 --100�� ���� ��¥ (�� ���� 3-31, 2-28/29
FROM dual;

--NEXT_DAY(date, weekday number( 1~7 ))
SELECT NEXT_DAY(SYSDATE, 7) -- ���� ��¥(2019/11/25)�� ���� �����ϴ� ù��° �����
FROM dual;
--�ڡڡڡڡ�