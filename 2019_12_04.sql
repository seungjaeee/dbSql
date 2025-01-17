--1.tax 테이블을 이용 시도/시군구별 인당 연말정산 신고액 구하기
--2.신고액이 많은 순서로 랭킹 부여하기
--랭킹 시도 시군구 인당연말정산 신고액
-- 1 서울특별시 서초구 7000
-- 2 서울특별시 강남구 6800
SELECT q.rn, q.sido, q.sigungu,인당연말정산신고액 , w.sido, w.sigungu, 도시발전지수
FROM
(SELECT ROWNUM rn, sido, sigungu, 인당연말정산신고액
FROM
(SELECT sido, sigungu, ROUND(sal / people, 1)인당연말정산신고액
FROM tax
ORDER BY 인당연말정산신고액 DESC)) q

LEFT OUTER JOIN 

(SELECT ROWNUM rn, sido, sigungu, 도시발전지수
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
ORDER BY 도시발전지수 DESC))w ON ( q.rn = w.rn)

ORDER BY q.rn;

--도시발전지수 시도, 시군구와 연말정산 납입금액의 시도, 시군구가
-- 같은 지역끼리 조인
-- 정렬순서는 tax 테이블의 id 컬럼순으로 정렬
-- 1 서울특별시  강남구  5.6   서울특별시 강남구 70.3

SELECT q.id, q.sido, q.sigungu,인당연말정산신고액 , w.sido, w.sigungu, 도시발전지수
FROM
(SELECT ROWNUM rn, id, sido, sigungu, 인당연말정산신고액
FROM
(SELECT id, sido, sigungu, ROUND(sal / people, 1)인당연말정산신고액
FROM tax
ORDER BY 인당연말정산신고액 DESC)) q

LEFT OUTER JOIN 

(SELECT ROWNUM rn, sido, sigungu, 도시발전지수
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
ORDER BY 도시발전지수 DESC))w ON (q.sido = w.sido AND w.sigungu = q.sigungu )
ORDER BY q.id;


--SMITH가 속한 부서 찾기
SELECT deptno
FROM emp
WHERE ename = 'SMITH';

SELECT *
FROM emp;
WHERE deptno = (SELECT deptno
               FROM emp
               WHERE ename = 'SMITH');

SELECT empno, ename, deptno, 
       (SELECT dname FROM dept WHERE dept.deptno = emp.deptno) dname
FROM emp;

--SCALAR SUBQUERY
--SELECT 절에 표현된 서브 쿼리
--한 행, 한 COLUMN을 조회해야 한다
SELECT empno, ename, deptno, 
       (SELECT dname FROM dept) dname
FROM emp;

--INLINE VIEW
--FROM절에 사용되는 서브쿼리

--SUBQUERY
--WHERE 절에 사용되는 서브쿼리
SELECT COUNT(*) cnt
FROM emp
WHERE sal > (SELECT AVG(sal)
            FROM emp);
            
--평균급여보다 높은 돈을 받는 직원들의 정보조회
SELECT empno, ename, job, mgr, hiredate, sal, comm, deptno
FROM emp
WHERE sal > (SELECT AVG(sal)
            FROM emp);

--SMITH와 WARD사원이 속한 부서의 모든 사원 정보를 조회하는 쿼리를 작성하세요

SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                 FROM emp
                 WHERE ename IN('SMITH','WARD'));

--1.SMITH, WARD가 속한 부서 조회 --> 20, 30
--2. 1번에 나온 결과값을 이용하여 해당 부서번호에 속하는 직원 조회


SELECT *
FROM emp
WHERE deptno IN(20,30);

--SMITH 혹은 WARD 보다 급여를 적게받는 직원조회

SELECT *
FROM emp
WHERE sal < ALL(SELECT sal --800, 1250 --> 1250보다 작은사람
                FROM emp 
                WHERE ename IN('SMITH','WARD'));
                
--관리자 역할을 하지 않는 사원 정보 조회
--NOT IN 연산자 사용시 NULL이 데이터에 존재하지 않아야 정상동작 한다
SELECT *
FROM emp -- 사원 정보 조회 --> 관리자역할을 하지 않는
WHERE empno NOT IN( SELECT nvl(mgr,-1) --NULL 값을 존재하지 않을만한 데이터로 치환
                FROM emp);

SELECT *
FROM emp -- 사원 정보 조회 --> 관리자역할을 하지 않는
WHERE empno NOT IN( SELECT mgr --NULL 값을 존재하지 않을만한 데이터로 치환
                FROM emp
                WHERE mgr IS NOT NULL);

--pairwise (여러 컬럼의 값을 동시에 만족 해야하는 경우)
--ALLEN과 CLARK의 매니저와 부서번호가 동시에 같은 사원 정보 조회
--7698, 30
--7839, 10
SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN(7499, 7782));

--매니저가 7698 이거나 7839 이면서
--소속부서가 10번 이거나 30번인 직원 정보 조회
--7698, 10
--7698, 30
--7839, 10
--7839, 30
SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN(7499, 7782))
AND deptno IN (SELECT deptno
               FROM emp
               WHERE empno IN(7499, 7782));
               
--비상호 연관 서브 쿼리
--메인쿼리의 컬럼을 서브쿼리에서 사용하지 않는 형태의 서브 쿼릐

--비상호 연관 서브쿼리의 경우 메인쿼리에서 사용하는 테이블, 서브쿼리 조회 순서를 
--성능적으로 유리한쪽으로 판단하여 순서를 결정한다.
--메인쿼리의 emp 테이블을 먼저 읽을수도 있고, 서브쿼리의 emp 테이블을 먼저 읽을 수도 있다.

--비상호 연관 서브쿼리에서 서브쿼리쪽 테이블을 먼저 읽을떄는
--서브쿼리가 제공자역할을 했다 라고 모 도서에서 표현
--비상호 연관 서브쿼리에서 서브쿼리쪽 테이블을 나중에 읽을떄는
--서브쿼리가 확인자 역할을 했다 라고 모 도서에서 표현

--직원의 급여 평균보다 높은 급여를 받는 직원 정보 조회
--직원의 급여평균
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
             FROM emp);
             
--상호연관 서브쿼리
--해당직원이 속한 부서의 급여평균보다 높은 급여를 받는 직원 조회

SELECT *
FROM emp m
WHERE sal > (SELECT AVG(sal)
             FROM emp
             WHERE deptno = m.deptno);

--10번부서의 급여평균
SELECT AVG(sal)
FROM emp
WHERE deptno = 30;