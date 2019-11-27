SELECT *  --dept 테이블 조회
FROM dept;

DESC emp; --<- emp테이블의 데이터들의 타입을 확인함.(숫자,문자 등)



--내년도 건강검진 대상자를 조회하는 쿼리 작성
SELECT empno, ename,hiredate,
            CASE
                WHEN MOD(TO_CHAR(hiredate, 'yyyy'), 2) =
                     MOD(TO_CHAR(SYSDATE, 'YYYY')+1, 2)
                THEN '건강검진 대상자'
                ELSE '건강검진 비대상자'
                
            END
FROM emp;

SELECT empno, ename, hiredate,
            CASE
                WHEN MOD(TO_CHAR(hiredate, 'yyyy'), 2) =
                     MOD(TO_CHAR(SYSDATE, 'yyyy')+1, 2)
                THEN '건강검진 대상자'
                ELSE '건강검진 비대상자'
            END
FROM emp;

SELECT userid, usernm, alias, reg_dt,
        CASE
            WHEN reg_dt IS NULL
            THEN '건강검진 비대상자'
            ELSE '건강검진 대상자'
        END contact_to_doctor
FROM users;

SELECT a.userid, a.usernm, a.alias, a.reg_dt,
       DECODE(MOD(a.yyyy, 2), MOD(a.this_yyyy, 2), '건강검진대상', '건강검진비대상') contacttodoctor
FROM
(SELECT a.*
FROM
(SELECT userid, usernm, alias, TO_CHAR(reg_dt, 'yyyy') yyyy,
       TO_CHAR(SYSDATE, 'yyyy') this_yyyy
FROM users)a);

--GROUP FUNCTION
--특정 컬럼이나, 표현을 기준으로 여러행의 값을 한행의 결과로 생성
--COUNT 건수, SUM 합계, AVG 평균, MAX 최대값, MIN 최소값
--전체 직원을 대상으로 (14건 -> 1건)

DESC emp;
SELECT MAX(sal) m_sal, --가장 높은 급여
       MIN(sal) min_sal, --가장 낮은 급여
       ROUND(AVG(sal), 2) avg_sal, --전 직원의 급여 평균
       SUM(sal) sum_sal, --전 직원의 급여 합
       COUNT(sal) count_sal, --급여 건수 (null이 아닌 값이면 1건)
       COUNT(mgr) count_mgr, --직원 관리자 건수 (KING의 경우 MGR가 없다)
       COUNT(*) count_row --특정 컬럼의 건수가 아니라 행의 개수를 알고 싶을때
FROM emp;

--부서번호별로 그룹함수 적용
SELECT deptno,
       MAX(sal) m_sal, --부서에서 가장 높은 급여
       MIN(sal) min_sal, --부서에서가장 낮은 급여
       ROUND(AVG(sal), 2) avg_sal, --부서 직원의 급여 평균
       SUM(sal) sum_sal, --부서 직원의 급여 합
       COUNT(sal) count_sal, --부서의 급여 건수 (null이 아닌 값이면 1건)
       COUNT(mgr) count_mgr, --부서 직원의 직원 관리자 건수 (KING의 경우 MGR가 없다)
       COUNT(*) count_row --부서의 조직원 수

FROM emp
GROUP BY deptno;

SELECT deptno, ename,
       MAX(sal) m_sal, --부서에서 가장 높은 급여
       MIN(sal) min_sal, --부서에서가장 낮은 급여
       ROUND(AVG(sal), 2) avg_sal, --부서 직원의 급여 평균
       SUM(sal) sum_sal, --부서 직원의 급여 합
       COUNT(sal) count_sal, --부서의 급여 건수 (null이 아닌 값이면 1건)
       COUNT(mgr) count_mgr, --부서 직원의 직원 관리자 건수 (KING의 경우 MGR가 없다)
       COUNT(*) count_row --부서의 조직원 수
FROM emp
GROUP BY deptno, ename;

--SELECT 절에는 GROUP BY 절에 표현된 컬럼 이외의 컬럼이 올 수 없다
--논리적으로 성립이 되지 않음 (3명의 직원 정보를 한건의 데이터로 그루핑)
--단, 예외적으로 상수값들은 SELECT 절에 표현이 가능
SELECT deptno, 1, '문자열', SYSDATE,
       MAX(sal) m_sal, --부서에서 가장 높은 급여
       MIN(sal) min_sal, --부서에서가장 낮은 급여
       ROUND(AVG(sal), 2) avg_sal, --부서 직원의 급여 평균
       SUM(sal) sum_sal, --부서 직원의 급여 합
       COUNT(sal) count_sal, --부서의 급여 건수 (null이 아닌 값이면 1건)
       COUNT(mgr) count_mgr, --부서 직원의 직원 관리자 건수 (KING의 경우 MGR가 없다)
       COUNT(*) count_row --부서의 조직원 수
FROM emp
GROUP BY deptno;

--그룹함수에서는 NULL 컬럼은 계산에서 제외된다
--emp테이블에서 comm컬럼이 null이 아닌 데이터는 4건이 존재, 9건은 NULL
SELECT COUNT(comm) count_comm, --NULL이 아닌 값의 개수 4
       SUM(comm) sum_comm,
       SUM(sal) sum_sal,--NULL값을 제외, 300+500+1400+0 = 2200
       SUM(sal + comm) tot_sal_sum,
       SUM(sal + NVL(comm, 0)) tot_sal_sum1
FROM emp;

--WHERE 절에는 GROUP 함수를 표현 할 수 없다
--부서별 최대 급여 구하기
--부서별 최대 급여 값이 3000이 넘는 행만 구하기
--deptno, 최대급여
SELECT deptno, MAX(sal) max_sal
FROM emp
WHERE MAX(sal) > 3000 -- ORA-00934 : WHERE 절에는 GROUP 함수가 올 수 없다
GROUP BY deptno;

SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno
HAVING MAX(sal) >= 3000;

        
        
        
        
        
        
        
SELECT MAX(sal) m_sal, --부서에서 가장 높은 급여
       MIN(sal) min_sal, --부서에서가장 낮은 급여
       AVG(sal) avg_sal, --부서 직원의 급여 평균
       SUM(sal) sum_sal, --부서 직원의 급여 합
       COUNT(sal) count_sal, --부서의 급여 건수 (null이 아닌 값이면 1건)
       COUNT(mgr) count_mgr, --부서 직원의 직원 관리자 건수 (KING의 경우 MGR가 없다)
       COUNT(*) count_all --부서의 조직원 수
FROM emp;

--위 문제를 부서번호 기준으로 쿼리를 작성하세요 (급여 평균은 소수점 둘째자리까지 나오도록)
SELECT deptno, 
       MAX(sal) m_sal,
       MIN(sal) min_sal,
       ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(sal) count_sal,
       COUNT(mgr) count_mgr,
       COUNT(*) count_all
FROM emp
GROUP BY deptno;


--위 문제에서 작성한 쿼리를 활용하여 deptno 대신 부서명이 나올수 있도록 수정하세요
SELECT CASE
            WHEN deptno = 10 THEN 'ACCOUNTING'
            WHEN deptno = 20 THEN 'RESEARCH'
            WHEN deptno = 30 THEN 'SALES'
       END dname,
       MAX(sal) m_sal,
       MIN(sal) min_sal,
       ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(sal) count_sal,
       COUNT(mgr) count_mgr,
       COUNT(*) count_all
FROM emp
GROUP BY deptno;

SELECT DECODE(deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES') dname,
       MAX(sal) m_sal,
       MIN(sal) min_sal,
       ROUND(AVG(sal), 2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(sal) count_sal,
       COUNT(mgr) count_mgr,
       COUNT(*) count_all
FROM emp
GROUP BY deptno
ORDER BY deptno;

--emp테이블을 이용하여 직원의 입사 년월별로 몇명의 직원이 입사했는지 조회하는 쿼리를 작성하세요

--hiredate 컬럼의 값을 yyyymm 형식으로 만들기
--date 타입을 문자열로 변경(yyyymm)
SELECT TO_CHAR(hiredate, 'yyyymm') hire_yyyymm, COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'yyyymm');

SELECT hire_yyyymm, count(*) cnt
FROM
    (SELECT TO_CHAR(hiredate, 'YYYYMM') hire_yyyymm
    FROM emp)
GROUP BY hire_yyyymm;

--emp테이블을 이용하여 직원의 입사 년별로 몇명의 직원이 입사했는지 조회하는 쿼리를 작성하세요
SELECT TO_CHAR(hiredate, 'yyyy') hire_yyyy, COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'yyyy');

--dept테이블의 부서 수 구하기
SELECT COUNT(*) cnt, COUNT(deptno), COUNT(loc)
FROM dept;

DESC dept;

--직원이 속한 부서의 개수를 조회하는 쿼리(emp테이블 사용)
SELECT COUNT(deptno) cnt
FROM
(SELECT deptno
FROM emp
GROUP BY deptno);

SELECT COUNT(COUNT(deptno)) cnt --카운트를 두번 사용할수도 있다.
FROM emp
GROUP BY deptno;

SELECT COUNT(DISTINCT deptno) cnt
FROM emp;

--JOIN
--1.테이블 구조변경(컬럼 추가)
--2.추가된 컬럼에 값을 update
--3.dname 컬럼을 emp 테이블에 추가
DESC dept;

--컬럼추가(dname, VARCHAR2(14))
ALTER TABLE emp ADD (dname VARCHAR2(14));
DESC emp;

SELECT *
FROM emp;

UPDATE emp SET dname = CASE     --UPDATE 업데이트할 테이블 SET 업데이트할 컬럼명
                            WHEN deptno = 10 THEN 'ACCOUNTING'
                            WHEN deptno = 20 THEN 'RESEARCH'
                            WHEN deptno = 30 THEN 'SALES'
                        END;
commit;

SELECT empno, ename, deptno, dname
FROM emp;

-- SALES --> MARKET SALES
--총 6건의 데이터 변경이 필요하다
--값의 중복이 있는 형태(반 정규형)
UPDATE emp SET dname = 'MARKET SALES'   -- 'SALES' 를 'MARKET SALES' 로 바꾸기
WHERE dname = 'SALES';  

--emp 테이블, dept 테이블 조인
SELECT ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;
