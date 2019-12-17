-- WITH
-- WITH 블록이름 AS (
--    서브쿼리
-- )
--SELECT *
--FROM 블록이름

-- deptno, avg(sal) avg_sal
-- 단 해당부서의 급여평균이 전체 직원의 급여 평균보다 높은 부서에 한해 조회
SELECT deptno, avg(sal) avg_sal
FROM emp
GROUP BY deptno
HAVING avg(sal) > ( SELECT avg(sal) FROM emp);

--WITH 절을 사용하여 위의 쿼리를 작성
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

--계층쿼리
--달력만들기
--CONNECT BY LEVEL <= N
--테이블의 ROW 건수를 N만큼 반복한다
--CONNECT BY LEVEL 절을 사용한 쿼리에서는
--SELECT 절에서 LEVEL 이라는 특수 컬럼을 사용할 수 있다
--계층을 표현하는 특수 컬럼으로 1부터 증가하며 ROWNUM과 유사하지만
--나중에 배우게될 START WITH, CONNECT BY 절에서 다른 점을 배우게 된다.

--2019년 11월은 30일까지 존재
--일자 + 정수 = 정수만큼 미래의 일자
--201911 -- > 해당년월의 날짜가 몇일까지 존재 하는가?
--1.일 2.월....7.토
 --일요일이면 날짜, 화요일이면 날짜, 수요일이면 날짜
SELECT /*dt,d,*/iw,
       MAX(DECODE(d, 1, dt))일, MAX(DECODE(d, 2, dt))월, MAX(DECODE(d, 3, dt))화,
       MAX(DECODE(d, 4, dt))수, MAX(DECODE(d, 5, dt))목, MAX(DECODE(d, 6, dt))금,
       MAX(DECODE(d, 7, dt))토
FROM
(SELECT TO_DATE(:yyyymm,' yyyymm')+ (LEVEL -1) dt,
       TO_CHAR(TO_DATE(:yyyymm,' yyyymm')+ (LEVEL -1),'d') d,
       TO_CHAR(TO_DATE(:yyyymm,' yyyymm')+ (LEVEL ),'iw') iw
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'yyyymm')),'dd'))
GROUP BY iw
ORDER BY iw;



SELECT /*dt,d,*/iw,
       DECODE(d, 1, dt)일, DECODE(d, 2, dt), DECODE(d, 3, dt)화,
       DECODE(d, 4, dt)수, DECODE(d, 5, dt), DECODE(d, 6, dt)금,
       DECODE(d, 7, dt)토
FROM
(SELECT TO_DATE(:yyyymm,' yyyymm')+ (LEVEL -1) dt,
       TO_CHAR(TO_DATE(:yyyymm,' yyyymm')+ (LEVEL -1),'d') d,
       TO_CHAR(TO_DATE(:yyyymm,' yyyymm')+ (LEVEL ),'iw') iw
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'yyyymm')),'dd'));


SELECT /*dt,d,*/ dt -(d-1),
      
       MAX(DECODE(d, 1, dt))일, MAX(DECODE(d, 2, dt))월, MAX(DECODE(d, 3, dt))화,
       MAX(DECODE(d, 4, dt))수, MAX(DECODE(d, 5, dt))목, MAX(DECODE(d, 6, dt))금,
       MAX(DECODE(d, 7, dt))토
FROM
(SELECT TO_DATE(:yyyymm,' yyyymm')+ (LEVEL -1) dt,
       TO_CHAR(TO_DATE(:yyyymm,' yyyymm')+ (LEVEL -1),'d') d,
       TO_CHAR(TO_DATE(:yyyymm,' yyyymm')+ (LEVEL ),'iw') iw
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'yyyymm')),'dd') + TO_CHAR(TO_DATE(:yyyymm,' yyyymm')+ (LEVEL -1),'d'))
GROUP BY dt -(d-1)
ORDER BY dt -(d-1);








SELECT /*dt,d,*/iw,
       MAX(DECODE(d, 1, dt))일, MAX(DECODE(d, 2, dt))월, MAX(DECODE(d, 3, dt))화,
       MAX(DECODE(d, 4, dt))수, MAX(DECODE(d, 5, dt))목, MAX(DECODE(d, 6, dt))금,
       MAX(DECODE(d, 7, dt))토
FROM
(SELECT TO_DATE(:yyyymm,' yyyymm')+ (LEVEL -1) dt,
       TO_CHAR(TO_DATE(:yyyymm,' yyyymm')+ (LEVEL -1),'d') d,
       TO_CHAR(TO_DATE(:yyyymm,' yyyymm')+ (LEVEL ),'iw') iw
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'yyyymm')),'dd'))
GROUP BY iw
ORDER BY 토;


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
START WITH deptcd='dept0' -- 시작점은 deptcd = 'dept0' --> XX회사(최상위조직)
CONNECT BY PRIOR deptcd = p_deptcd --PRIOR : 이미 읽은것
ORDER BY level;

/*
    dept0(XX회사)
        dept0_00(디자인부)
            dept0_00_0(디자인팀)
        dept0_01(정보기획부)
            dept0_01_0(기획팀)
                dept0_00_0_0(기획파트)
        dept0_02(정보시스템부)
            dept0_02_0(개발1팀)
            dept0_02_1(개발2팀)





