

SELECT dept_h.*, LEVEL, LPAD(' ', (LEVEL -1)*3) || deptnm
FROM dept_h
START WITH deptcd='dept0' -- �������� deptcd = 'dept0' --> XXȸ��(�ֻ�������)
CONNECT BY PRIOR deptcd = p_deptcd --PRIOR : �̹� ������
ORDER BY level;

SELECT LPAD('XXȸ��', 15, '*'),
       LPAD('XXȸ��', 15)
FROM dual;


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
*/
SELECT LEVEL, deptcd, LPAD(' ',(LEVEL-1)*3)||deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptnm = '�����ý��ۺ�'
CONNECT BY PRIOR deptcd = p_deptcd;

SELECT *
FROM dept_h;
--��������[dept0_00_0)�� �������� ����� �������� �ۼ�
--�ڱ� �μ��� �θ� �μ��� ������ �Ѵ�
SELECT deptcd, LPAD(' ',(LEVEL -1)*3)||deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_00_0'
--CONNECT BY PRIOR p_deptcd = deptcd
CONNECT BY deptcd = PRIOR p_deptcd;


SELECT LPAD(' ',(LEVEL-1)*3)||s_id s_id, value
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id;


SELECT LPAD(' ',(LEVEL-1)*4)||org_cd org_cd, no_emp
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;

SELECT *
FROM no_emp;

-- pruning branch (����ġ��)
-- ���� ������ �������
-- FROM -> START WITH ~ CONNECT BY -> WHERE
-- ������ CONNECT BY ���� ����� ���
--  . ���ǿ� ���� ���� ROW�� ������ �ȵǰ� ����
-- ������ WHERE ���� ����� ���
--  . START WITH ~ CONNECT BY ���� ���� ���������� ���� �����
--  WHERE���� ����� ��� ���� �ش��ϴ� �����͸� ǥ��

--�ֻ��� ��忡�� ��������� Ž��
--CONNECT BY ���� deptnm != '������ȹ��' ������ ����� ���
SELECT *
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd AND deptnm != '������ȹ��';

--WHERE���� deptnm != '������ȹ��' ������ ����� ���
-- ���������� �����ϰ��� ���� ����� WHERE �� ������ ����
SELECT *
FROM dept_h
WHERE deptnm != '������ȹ��'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

--���� �������� ��� ������ Ư�� �Լ�
-- CONNECT_BY_ROOT(col) ���� �ֻ��� row�� col ���� �� ��ȸ
-- SYS_CONNECT_BY_PATH(col, ������) : �ֻ��� row���� ���� row���� col����
-- �����ڷ� �������� ���ڿ� (EX : XXȸ�� - �����κ�-��������)
-- CONNECT_BY_ISLEAF : �ش� ROW�� ������ �������(leaf Node)
-- leaf node : 1, node : 0
SELECT deptcd, LPAD(' ', (LEVEL-1)*4) || deptnm deptnm,
       CONNECT_BY_ROOT(deptnm) c_root,
       LTRIM(SYS_CONNECT_BY_PATH(deptnm,'-'),'-') sys_path,
       CONNECT_BY_ISLEAF isleaf
FROM dept_h
WHERE deptnm != '������ȹ��'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

--h6  ���� sql pt 87
SELECT seq, LPAD(' ',(LEVEL-1)*3)||title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq;

--h7 ���� �ֽű��� ���� �������� ���� (�߸��� ���)
SELECT seq, LPAD(' ',(LEVEL-1)*3)||title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq 
ORDER BY seq DESC;

--���� ������ ������ ���¿��� ���� �ϴ� ��� ( ORDER SIBLINGS BY)
SELECT seq, LPAD(' ',(LEVEL-1)*3)||title title        
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq 
ORDER SIBLINGS BY seq DESC;

SELECT *
FROM board_test;







