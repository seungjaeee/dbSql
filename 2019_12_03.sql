SELECT *
FROM fastfood;


--���� ���������� ���� ������ ����
-- (����ŷ ���� + KFC ���� + �Ƶ����� ����) / �Ե����� ����
--���� / �õ� / �ñ��� / ���ù�������(�Ҽ��� ù��° �ڸ�����)
-- 1 / ����Ư���� / ���ʱ� / 7.5
-- 2 / ����Ư���� / ������ / 7.2

--�ش� �õ�, �ñ����� ��������� �Ǽ��� �ʿ�
SELECT ROWNUM rn, sido, sigungu, ���ù�������
FROM
(SELECT  a.sido, a.sigungu, ROUND(a.cnt/b.cnt, 1) ���ù�������
FROM
(SELECT sido,sigungu, count(*) cnt --����ŷ, KFC, �Ƶ����� �Ǽ�
FROM fastfood
WHERE gb IN('KFC','����ŷ','�Ƶ�����')
GROUP BY sido,sigungu) a,

(SELECT sido,sigungu, count(*) cnt --�Ե����� �Ǽ�
FROM fastfood
WHERE gb IN('�Ե�����')
GROUP BY sido,sigungu) b
WHERE a.sido = b.sido
AND a.sigungu = b.sigungu
ORDER BY ���ù������� DESC);


--�ϳ��� SQL�� �ۼ����� ������
--fastfood ���̺��� �̿��Ͽ� �������� sql ���� �����
--������ ����ؼ� ���� ���������� ���
--������ ������ ����ŷ 1 + �Ƶ����� 3 + KFC 0 / 8
--������ ���� 2 + �Ƶ����� 2 + KFC 0 / 8
--������ ���� 6 + �Ƶ����� 7 + KFC 4 / 12
--������ �߱� 2 + �Ƶ����� 4 + KFC 1 / 6
--������ ����� 0 + �Ƶ����� 2 + KFC 0 / 7

SELECT ROUND((2)/7, 1)
FROM fastfood;
