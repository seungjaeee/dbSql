--별칭 : 테이블, 컬럼을 다른 이름으로 저장
-- [AS] 별칭명
-- SELECT empno [AS] eno
-- FROM emp e

--SYNONYM (동의어)
--오라클 객체를 다른이름으로 부를 수 있도록 하는 것
--만약에 emp 테이블을 e 라고 하는 SYNONYM(동의어)로 생성을 하면
-- 다음과 같이 SQL을 작성 할 수 있다
-- SELECT *
-- FROM e;


--system계정에서 작업 ----------------------------
--SJSJ계정에 SYNONYM 생성 권한을 부여
GRANT CREATE SYNONYM TO SJSJ;
------------------------------------------------여기까지

--emp 테이블을 사용하여 synonym e를 생성
--CREATE SYNONYM 시노님이름 FOR 오라클객체;
CREATE SYNONYM e FOR emp;

--emp 라는 테이블명 대신에 e 라고 하는 시노님을 사용하여 쿼리를 작성 할 수 있다

SELECT *
FROM emp;

SELECT *
FROM e;

--SJSJ 계정의 fastfood 테이블을 hr 계정에서도 볼 수 있도록
--테이블 조회 권한을 부여
GRANT SELECT ON fastfood TO hr;
CREATE SYNONYM fastfood FOR hr;

--DML
--  SELECT /INSERT /UPDATE / DELETE /INSERT ALL / ★MERGE★
--TCL
--  COMMIT / ROLLBACK / [SAVEPOINT]
--DDL
--  CREATE 객체
--  ALTER
--  DROP

SELECT *
FROM dictionary;

SELECT *
FROM emp
WHERE empno = :empno;

--동일한 SQL의 개념에 따르면 아래 SQL들은 다르다
SELECT /* 201911_205 */* FROM emp;
SELECT /* 201911_205 */* FROM EMP;
SELECt /* 201911_205 */* FROM EMP;

SELECt /* 201911_205 */* FROM EMP WHERE empno = 7369;
SELECt /* 201911_205 */* FROM EMP WHERE empno = 7499;
SELECt /* 201911_205 */* FROM EMP WHERE empno = :empno;

--multiple insert

--emp테이블의 empno, ename 컬럼으로 emp_test, emp_test2 테이블을
--생성(CTAS, 데이터도 같이 복사)
CREATE TABLE emp_test AS
SELECT empno, ename
FROM emp;

CREATE TABLE emp_test2 AS
SELECT empno, ename
FROM emp;

SELECT *
FROM emp_test2;

--unconditional insert
--여러 테이블에 데이터를 동시에 입력
--brown, cony 데이터를 emp_test, emp_test2 테이블에 동시에 입력
INSERT ALL 
    INTO emp_test
    INTO emp_test2
SELECT 9999, 'brown' FROM DUAL UNION ALL
SELECT 9998, 'cony' FROM DUAL;

SELECT *
FROM emp_test
WHERE empno > 9000;

rollback;
--테이블별로 입력되는 데이터의 컬럼을 제어 가능
INSERT ALL 
    INTO emp_test(empno, ename) VALUES(eno, enm)
    INTO emp_test2(empno) VALUES(eno)
SELECT 9999 eno, 'brown'enm FROM DUAL UNION ALL
SELECT 9998, 'cony' FROM DUAL;

SELECT *
FROM emp_test
WHERE empno > 9000;

SELECT *
FROM emp_test2
WHERE empno > 9000;

rollback;

--CONDITIONAL INSERT
--조건에 따라 테이블에 데이터를 입력
/* 
    CASE
        WHEN 조건 THEN ---- IF
        WHEN 조건 THEN ---- ELSE IF
        ELSE ----          ELSE

*/
rollback;
INSERT ALL
    WHEN eno > 9000 THEN
        INTO emp_test (empno,ename) VALUES(eno, enm)
        WHEN eno > 9500 THEN
        INTO emp_test (empno,ename) VALUES(eno, enm)
    ELSE
        INTO emp_test2(empno) VALUES(eno)
SELECT 9999 eno, 'brown'enm FROM DUAL UNION ALL
SELECT 8998, 'cony' FROM DUAL;

SELECT *
FROM emp_test
WHERE empno > 9000 UNION ALL
SELECT *
FROM emp_test2
WHERE empno > 8000;

--첫번째로 만나는 조건과 else만 수행함
INSERT FIRST
    WHEN eno > 9000 THEN
        INTO emp_test (empno,ename) VALUES(eno, enm)
        WHEN eno > 9500 THEN
        INTO emp_test (empno,ename) VALUES(eno, enm)
    ELSE
        INTO emp_test2(empno) VALUES(eno)
SELECT 9999 eno, 'brown'enm FROM DUAL UNION ALL
SELECT 8998, 'cony' FROM DUAL;

SELECT *
FROM emp_test
WHERE empno > 9000 UNION ALL
SELECT *
FROM emp_test2
WHERE empno > 8000;