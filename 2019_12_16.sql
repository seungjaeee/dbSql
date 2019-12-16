--GROUPING SETS(co1,co2)
--다음과 결과가 동일
--개발자가 GROUP BY의 기준을 직접 명시한다
--ROLLUP과 달리 방향성을 갖지 않는다
--GROUPING SETS(co1,co2)

-- GROUP BY col1
--UNION ALL
--GROUP BY col2

--emp 테이블에서 직원의 job별 급여(sal)+상여(comm)합,
--                  deptno(부서)별 급여+상여 합 구하기
--기존방식 GROUP FUNCTION : 2번의 sql 작성 필요(UNION , UNION ALL)
SELECT job,sum((sal) + NVL(comm,0)) sal_comm_sum
FROM emp
GROUP BY job
UNION ALL
SELECT '',deptno, sum((sal) + NVL(comm, 0)) sal
FROM emp
GROUP BY deptno;

--GROUPING SETS 구문을 이용하여 위의 sql 집합연산을 사용하지 않고
--테이블을 한번 읽어서 처리
SELECT job, deptno, sum(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY GROUPING SETS (job,deptno);

-- job, deptno를 그룹으로 한 sal+comm 합
-- mgr을 그룹으로 한 sal+comm 합
--GROUP BY job, deptno
--UNIOB ALL
--GROUP BY mgr
--> GROUPING SETS((job, deptno), mgr)
SELECT job,deptno,mgr, sum(sal+NVL(comm,0)) sal_comm_sum,GROUPING(job),GROUPING(deptno),GROUPING(mgr)
FROM emp
GROUP BY GROUPING SETS((job,deptno),mgr);

--CUBE(co11, col2 ...)
--나열된 컬럼의 모든 가능한 조합으로 GROUP BY subset을 만든다
--CUBE에 나열된 컬럼이 2개인 경우 : 가능한 조합 4개
--CUBE에 나열된 컬럼이 3개인 경우 : 가능한 조합 8개
--CUBE에 나열된 컬럼수를 2의 제곱승 한 결과가 가능한 조합 개수가 된다.
--컬럼이 조금만 많아져도 가능한 조합이 기하급수적으로 늘어나기 때문에 많이 안씀

--job, deptno를 이용하여 cube 적용
SELECT job,deptno, sum(sal + nvl(comm,0)) sal
FROM emp
GROUP BY CUBE(job,deptno);
-- job, deptno
-- 1, 1 --> GROUP BY job, deptno
-- 1, 0 -->GROUP BYjob
-- 0, 1 -->GROUP BY deptno
-- 0, 0 -->GROUP BY -- emp테이블의 모슨댛에 대해 GROUP BY

--GROUP BY 응용
--GROUP BY, ROLLUP, CUBE를 석어 사용하기
-- 가능한 조합을 생각해보면, 쉽게 결과를 예측 할 수 있다
--GROUP BY job, rollup(deptno), cube(mgr)
SELECT job, deptno, mgr, sum(sal + nvl(comm,0)) sal
FROM emp
GROUP BY job, ROLLUP(deptno), cube(mgr);

SELECT job, sum(sal)
FROm emp
GROUP BY job, job;


--dept테이블을 이용하여 dept_test 테이블 생성
--dept_test 테이블에 empcnt (NUMBER) 컬럼 생성
--서브쿼리를 이용하여 dept_test테이블의 empcnt 컬럼에 해당 부서원 수를 update하는 쿼리 작성

CREATE TABLE dept_test AS
SELECT *
FROM dept_test;

ALTER TABLE dept_test ADD(empcnt NUMBER);

UPDATE dept_test SET empcnt = (SELECT count(*) 
                               FROM emp 
                               WHERE emp.deptno = dept_test.deptno);
rollback;

SELECT *
FROM dept_test;

DROP TABLE dept_test;

CREATE TABLE dept_test AS
SELECT *
FROM dept;

INSERT INTO dept_test values(99, 'it1', 'daejeon');
INSERT INTO dept_test values(98, 'it2', 'daejeon');

DELETE FROM dept_test
WHERE deptno NOT IN (SELECT deptno
                     FROM emp
                     WHERE emp.deptno = dept_test.deptno);


DELETE FROM dept_test
WHERE deptno NOT IN (SELECT deptno
                     FROM emp
                     WHERE deptno IN(10,20,30));
SELECT *
FROM emp;
SELECT *
FROM dept_test;
rollback;

SELECT *
FROM emp_test;
DROP TABLE emp_test;

CREATE TABLE emp_test AS
SELECT *
FROM emp;

SELECT deptno, ROUND(avg(sal),1) + 200
FROM emp
GROUP BY deptno;


UPDATE emp_test SET sal = sal + 200
WHERE sal < (SELECT avg(sal)
             FROM emp
             WHERE emp.deptno = emp_test.deptno);


SELECT deptno, avg(sal)
FROM emp_test
GROUP BY deptno;
-- MERGE 구문을 이용한 업데이트
MERGE INTO emp_test a
USING (SELECT deptno, avg(sal) avg_sal
       FROM emp_test
       GROUP BY deptno) b
ON (a.deptno = b.deptno)
WHEN MATCHED THEN
    UPDATE SET sal = sal + 200
    WHERE a.sal < avg_sal;
    
    
MERGE INTO emp_test a
USING (SELECT deptno, avg(sal) avg_sal
       FROM emp_test
       GROUP BY deptno) b
ON (a.deptno = b.deptno)
WHEN MATCHED THEN
    UPDATE SET sal = CASE
                        WHEN a.sal < b.avg_sal THEN sal + 200
                        ELSE sal
                    END;
SELECT *
FROM emp_test;
             
             rollback;


             





