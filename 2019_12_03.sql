SELECT *
FROM fastfood;


--도시 발전지수가 높은 순으로 나열
-- (버거킹 개수 + KFC 개수 + 맥도날드 개수) / 롯데리아 개수
--순위 / 시도 / 시군구 / 도시발전지수(소수점 첫번째 자리까지)
-- 1 / 서울특별시 / 서초구 / 7.5
-- 2 / 서울특별시 / 강남구 / 7.2

--해당 시도, 시군구별 프렌차이즈별 건수가 필요
SELECT ROWNUM rn, sido, sigungu, 도시발전지수
FROM
(SELECT  a.sido, a.sigungu, ROUND(a.cnt/b.cnt, 1) 도시발전지수
FROM
(SELECT sido,sigungu, count(*) cnt --버거킹, KFC, 맥도날드 건수
FROM fastfood
WHERE gb IN('KFC','버거킹','맥도날드')
GROUP BY sido,sigungu) a,

(SELECT sido,sigungu, count(*) cnt --롯데리아 건수
FROM fastfood
WHERE gb IN('롯데리아')
GROUP BY sido,sigungu) b
WHERE a.sido = b.sido
AND a.sigungu = b.sigungu
ORDER BY 도시발전지수 DESC);


--하나의 SQL로 작성하지 마세요
--fastfood 테이블을 이용하여 여러번의 sql 실행 결과를
--손으로 계산해서 도시 발전지수를 계산
--대전시 유성구 버거킹 1 + 맥도날드 3 + KFC 0 / 8
--대전시 동구 2 + 맥도날드 2 + KFC 0 / 8
--대전시 서구 6 + 맥도날드 7 + KFC 4 / 12
--대전시 중구 2 + 맥도날드 4 + KFC 1 / 6
--대전시 대덕구 0 + 맥도날드 2 + KFC 0 / 7

SELECT ROUND((2)/7, 1)
FROM fastfood;
