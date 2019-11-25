GITHUB에 공유가 되있는 상태



1.github에서 저장소 clone

2. 이클립스 - 저장소 추가(git repsitories) window - Show View - others - git repsitories

3. 이클립스 - 추가된 저장소 선택, 

	      우클릭 import projects

4. package/project explorer

   해당 프로젝트 우클릭 - configure

			  convert faceted form

 

 

 

 

UPDATE emp 

SET comm = 0

WHERE empno = 7844;

 

--emp 테이블에서부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 조회 하세요 ( IN, NOT IN 연산자 사용금지)

SELECT *

FROM emp

WHERE DEPTNO != '10' -- <> 도 가능

AND hiredate >= TO_DATE('19810601', 'yyyymmdd');

 

--emp 테이블에서부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 조회 하세요 ( NOT IN 연산자 사용)

SELECT *

FROM emp

WHERE DEPTNO NOT IN (10)

AND hiredate >= TO_DATE('19810601', 'yyyymmdd');

 

--emp 테이블에서부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 조회 하세요 ( 10, 20, 30번만 있다고 가정하고 IN연산자 사용)

SELECT *

FROM emp

WHERE deptno IN (20, 30)

AND hiredate >= TO_DATE ('19810601', 'yyyymmdd');

 

--emp 테이블에서 job이 SALESMAN이거나 입사일자가 1981년 6월 1일 이후인 직원이 정보를 조회하세요

SELECT *

FROM emp

WHERE job = 'SALESMAN'

OR hiredate >= TO_DATE ('19810601', 'yyyymmdd');

 

--emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 조회하세요

SELECT *

FROM emp

WHERE job = 'SALESMAN' -- SALESMAN에 ' '을 안붙이면 컬럼으로 인식한다.

OR empno LIKE '78%'; -- LIKE 는 문자열에 대한 패턴검색이라서 ' '를 써야함

 

--emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 조회하세요 ( LIKE 연산자 사용 금지 )

--전제조건 : empno가 숫자여야된다 ( DESC emp. empno NUMBER )

DESC emp;

SELECT *

FROM emp

WHERE job = 'SALESMAN'

OR empno BETWEEN 7800 AND 7899;

 

--연산자 우선순위 ( AND > OR )

-- 직원 이름이 SMITH 이거나 ALLEN 이면서 job이 SALESMAN인 직원

SELECT *

FROM emp

WHERE ename = 'SMITH'

OR (ename = 'ALLEN' AND job = 'SALESMAN');

 

-- 직원 이름이 SMITH 이거나 ALLEN 이면서 job이 SALESMAN인 직원

SELECT *

FROM emp

WHERE (ename = 'SMITH' OR ename = 'ALLEN')

AND job = 'SALESMAN';

 

--emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하면서 입사일자가 1981년 6월 1일 이후인 직원의 정보를 조회하세요

SELECT *

FROM emp

WHERE job = 'SALESMAN'

OR (empno LIKE '78%' AND hiredate >= TO_DATE('19810601', 'yyyymmdd'));

 

SELECT *

FROM emp

WHERE job = 'SALESMAN'

OR (empno BETWEEN 7800 AND 7899

    AND hiredate >= TO_DATE ('19810601', 'yyyymmdd') );

    

    SELECT *

FROM emp

WHERE (job = 'SALESMAN'

OR empno BETWEEN 7800 AND 7899)

AND hiredate >= TO_DATE ('19810601', 'yyyymmdd');

 

--ORDER BY

-- ASC : 오름차순 (기본) -> 10 5 3 2 1  = 1 2 3 5 10 작은값부터 올라간다는 뜻

-- DESC : 내림차순 -> 10 5 3 2 1 순으로 큰값에서부터 내려간다는 뜻

-- ASC는 표기를 안할경우 기본값

-- DESC는 내림차순시 반드시 표기

 

/*

    SELECT col1, col2, ....

    FROM 테이블명

    WHERE coll = '값'

    ORDER BY 정렬기준컬럼1 [ASC / DESC], 정렬기준컬럼2.....[ASC / DESC]

*/

 

--emp 테이블에서 직원의 정보를 직원 이름(ename) 으로 오름차순 정렬

SELECT *

FROM emp

ORDER BY ename ASC; -- <- (ASC 생략 가능) 정렬기준을 작성하지 않을경우 오름차순 적용

 

--emp 테이블에서 직원의 정보를 직원 이름(ename) 으로 내림차순 정렬

SELECT *

FROM emp

ORDER BY ename DESC; -- DESC : 내림차순에 대한 키워드 (내림차순 할때 반드시 써줘야함)

 

--emp 테이블에서 직원의 정보를 부서번호로 오름차순(ASC) 정렬하고

-- 부서번호가 같을 때는 sal(DESC) 내림차순 정렬

-- 급여(sal)가 같을때는 이름으로 오름차순(ASC) 정렬 한다.

SELECT *

FROM emp

ORDER BY deptno, sal DESC, ename;

 

--정렬 컬럼을 ALIAS로 표현

SELECT deptno, sal, ename nm

FROM emp

ORDER BY nm;

 

--조회하는 컬럼의 위치 인덱스로 표현 가능, 추천하지않음.( 컬럼 추가시 의도하지 않은 결과가 나올수 있음)

SELECT deptno, sal, ename nm

FROM emp

ORDER BY 3; -- 3은 nm을 뜻함. 2는 sal 

 

--dept 테이블의 모든 정보를 부서이름으로 오름차순 정렬로 조회되도록 쿼리를 작성하세요

SELECT *

FROM dept

ORDER BY dname;

 

--ORDERBY 1

--dept 테이블의 모든 정보를 부서위치로 내림차순 정렬로 조회되도록 쿼리를 작성하세요

SELECT *

FROM dept

ORDER BY loc DESC;

 

--ORDERBY 2

-- emp 테이블에서 상여 정보가 있는 사람들만 조회하고, 상여를 많이 받는 사람이 먼저 조회되도록 하고, 

-- 상여가 같을 경우 사번으로 오름차순 정렬하라. (상여가 0인 사람은 상여가 없는 것으로 간주)

SELECT *

FROM emp

WHERE comm IS NOT NULL

AND comm != 0

ORDER BY comm DESC, empno;

 

--ORDERBY 3

--emp 테이블에서 관리자가 있는 직원만 조회하고 직군 순으로 오름차순 정렬(ASC), 

--직군이 같을경우 사원번호가 큰사람이 먼저 조회되도록 (DESC)

SELECT *

FROM emp

WHERE mgr IS NOT NULL

ORDER BY job, empno DESC;

 

--ORDERBY 4

--emp 테이블에서 10번 부서(deptno) 혹은 30번 부서에 속하는 사람중 급여(sal)가 1500이 넘는 사람들만 조회하고 

--이름으로 내림차순 정렬되도록 쿼리를 작성하세요

SELECT *

FROM emp

WHERE deptno IN (10, 30) -- deptno = 10 OR deptno = 30 도 같음

AND sal > 1500

ORDER BY ename DESC;

 

--ROWNUM : 컬럼에 순차적으로 번호를 부여함

SELECT ROWNUM, empno, ename

FROM emp;

 

SELECT ROWNUM, empno, ename

FROM emp

WHERE ROWNUM = 1; -- ROWNUM = equal 비교는 1만 가능

 

SELECT ROWNUM, empno, ename

FROM emp

WHERE ROWNUM <= 2; -- <=, (<) 부등호 ROWNUM을 1부터 순차적으로 부등호를 사용해서 조회하는 경우는 가능

 

SELECT ROWNUM, empno, ename

FROM emp

WHERE ROWNUM BETWEEN 1 AND 20; -- 1부터 시작하는 경우 가능 2는 아무것도 안나옴

 

--SELECT 절과 ORDER BY 구문의 실행순서

--SELECT -> ROWNUM -> ORDER BY 

SELECT ROWNUM, empno, ename

FROM emp

ORDER BY ename;

 

--INLINE VIEW(직접 기술을 한것)를 통해 정렬을 먼저 실행하고, 해당 결과에 ROWNUM을 적용

-- *을 표현하고, 다른 컬럼 표현식을 썻을 경우 *앞에 테이블명이나, 테이블 별칭을 적용해야함.

SELECT ROWNUM, a.*        -- empno, ename

FROM (SELECT empno, ename 

      FROM emp

      ORDER BY ename) a;

      

SELECT emp.*

FROM emp;

 

SELECT ROWNUM, a.*

FROM (SELECT empno, ename, deptno

     FROM emp

     ORDER BY deptno) a;

     

--ROWNUM 1

--emp 테이블에서 ROWNUM 값이 1~10인 값만 조회하는 쿼리를 작성하세요

SELECT ROWNUM rn, empno, ename

FROM emp

WHERE ROWNUM BETWEEN 1 AND 10;

 

--ROWNUM 2

-- ROWNUM이 11~14인 데이터

SELECT ROWNUM rn, e.*

FROM (SELECT empno, ename

     FROM emp                       -- 내가한것. 틀림

     WHERE ROWNUM BETWEEN 1 AND 20)

WHERE rn BETWEEN 11 AND 14 e;

 

SELECT a.*

FROM

    (SELECT ROWNUM rn, empno, ename     -- 정답

    FROM emp) a

WHERE rn BETWEEN 11 AND 20;

 

--ROWNUM 3

--emp 테이블에서 ename으로 정렬한 결과의 11~14번째 행만 조회하는 쿼리 작성 

--(empno, ename 컬럼과 행번호만 조회)
SELECT *
FROM
(SELECT ROWNUM rn, a.*
FROM
(SELECT empno, ename
FROM emp
ORDER BY ename)a)
WHERE rn BETWEEN 11 AND 14;
(SELECT ROWNUM rn, a.*a)











SELECT *
FROM
(SELECT ROWNUM RN,a.*
FROM
    (SELECT empno, ename
    FROM emp
    ORDER BY ename)a)
WHERE RN BETWEEN 11 AND 14;











SELECT *
FROM
(SELECT ROWNUM RN,a.*
FROM
    (SELECT empno, ename
    FROM emp
    ORDER BY ename)a)
WHERE RN BETWEEN 11 AND 14;
