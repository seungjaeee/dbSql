SELECT *
FROM dept, emp
WHERE dept.deptno = emp.deptno;
--dept 먼저 읽는 형태
-- join 컬럼을 hash 함수로 돌려서 해당 해쉬함수에 해당하는 bucket에 데이터를 넣는다
-- 10 --> ccc1122 (hashvalue)

--emp 테이블에 대해 위의 진행을 동일하게 진행
-- 10 --> ccc1122 (hashvalue)


-- 사원번호, 사원이름, 부서번호, 급여, 부서원의 전체 급여합
SELECT empno, ename, deptno, sal, 
        SUM(sal) OVER(ORDER BY sal 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum, -- 가장 처음부터 현재 행까지
        --바로 이전행이랑 현재행까지의 급여 합
        SUM(sal) OVER(ORDER BY sal
        ROWS BETWEEN 1 PRECEDING AND CURRENT ROW)c_sum2
FROM emp;

--응용 SQL PT 127
SELECT empno, ename, deptno,sal,
    SUM(sal) OVER(PARTITION BY deptno ORDER BY sal,empno
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp;

--ROWS 와 RANGE 차이 확인하기
SELECT empno, ename, deptno, sal,
    SUM(sal) OVER(ORDER BY sal ROWS UNBOUNDED PRECEDING) row_sum,
    SUM(sal) OVER(ORDER BY sal RANGE UNBOUNDED PRECEDING) range_sum,
    SUM(sal) OVER(ORDER BY sal) c_sum
FROM emp;

--PL/SQL
--PL/SQL 기본구조
--DECLARE : 선언부, 변수를 선언하는 부분
--BEGIN : PL/SQL의 로직이 들어가는 부분
--EXCEPTION : 예외처리부

SET SERVEROUTPUT ON; -- DBMS_OUTPUT.PUT_LINE 함수가 출력하는 결과를 화면에 보여주도록 활성화
DECLARE -- 선언부
    --java : 타입 변수명;
    --pl/sql : 변수명 타입;
--    v_dname VARCHAR2(14);
--    v_loc VARCHAR2(13);
    --테이블 컬럼의 정의를 참조하여 데이터 타입을 선언한다
    v_dname dept.dname %TYPE;
    v_loc dept.loc %TYPE;
BEGIN
    --DEPT 테이블에서 10번 부서의 부서이름,loc 정보를 조회
    SELECT dname,loc
    INTO v_dname,v_loc--변수1,변수2
    FROM dept
    WHERE deptno = 10;
    
    -- String a = "t";
    -- String b = "c";
    --System.out.println(a + b);
    dbms_OUTPUT.PUT_LINE(v_dname || v_loc);
END;
/ 
-- PL/SQL 블록을 실행 하라는 뜻 /다음에는 뭐가 오면 안됨.


--10번 부서의 부서이름, 위치지역을 조회해서 변수에 담고
--변수를 DBMS_OUTPUT.PUT_LINE함수를 이용하여 console에 출력
CREATE OR REPLACE PROCEDURE printdept
--파라미터명 IN/OUT 타입
-- p_파라미터이름 <- 파라미터 라는 뜻
( p_deptno IN dept.deptno %TYPE )
IS
--선언부(옵션)
    dname dept.dname %TYPE;
    loc dept.loc %TYPE;
    
--실행부
BEGIN
    SELECT dname, loc
    INTO dname, loc
    FROM dept
    WHERE deptno = p_deptno;
    
    DBMS_OUTPUT.PUT_LINE(dname || ' ' || loc);
--예외처리(옵션)
END;
/

exec printdept(40);

CREATE OR REPLACE PROCEDURE printemp
(p_empno IN emp.empno %TYPE)
IS
ename emp.ename %TYPE;
dname dept.dname %TYPE;

BEGIN
    SELECT ename,dname
    INTO ename,dname
    FROM emp,dept
    WHERE empno = p_empno
    AND emp.deptno = dept.deptno;
    
    DBMS_OUTPUT.PUT_LINE(ename || ' ' || dname);
END;
/
exec printemp(7788);

DESC emp;

SELECT ename,dname
   
    FROM emp,dept
    WHERE empno = 7369
    AND emp.deptno = dept.deptno;

SELECT *
FROM emp;

CREATE OR REPLACE PROCEDURE registdept_test
( p_deptno IN dept.deptno %TYPE,
  p_dname IN dept.dname %TYPE,
  p_loc IN dept.loc %TYPE)
  IS
deptno dept.deptno %TYPE;
dname dept.dname %TYPE;
loc dept.loc %TYPE;
BEGIN
    INSERT INTO dept_test VALUES(99,'ddit','daejeon');
    commit;
    DBMS_OUTPUT.PUT_LINE(deptno||dname||loc);
END;
/
exec registdept_test(99,'ddit','daejeon');

SELECT *
FROM dept_test;

DELETE dept_test
WHERE deptno = 99;








