SELECT *
FROM dept;

--dept 테이블에 부서번호 99, 부서명 ddit, 위치 daejeon
INSERT INTO dept VALUES(99,'ddit','daejeon');
commit;

--UPDATE : 테이블에 저장된 컬럼의 값을 변경
--UPDATE 테이블명 SET 컬럼명1 = 적용하려고 하는 값1, 컬럼명2 = 적용하려고 하는 값2.....
--[WHERE  row 조회 조건] <- []는 들어갈수도있고 안들어갈수도 있고 라는 뜻
--조회 조건에 해당하는 데이터만 업데이트가 된다

--부서번호가 99번인 부서의 부서명을 대덕IT로, 지역을 영민빌딩으로 변경
UPDATE dept SET dname = '대덕IT', loc = '영민빌딩'
WHERE deptno = 99;
commit;
--업데이트전에 업데이트 하려고하는 테이블을 WHERE절에 기술한 조건으로 SELECT를 하여
--업데이트 대상 ROW를 확인해보자.
SELECT *
FROM dept
WHERE deptno = 99;

--다음 쿼리를 실행하면 WHERE절에 ROW 제한 조건이 없기때문에
--dept 테이블의 모든 행에 대해 부서명, 위치 정보를 수정한다
UPDATE dept SET dname = '대덕IT', loc = '영민빌딩';

--Subquery를 이용한 UPDATE
--emp 테이블에 신규 데이터 입력
--사원번호 9999, 사원이름 brown, 업무 : null
INSERT INTO emp(empno, ename) VALUES (9999, 'brown');
commit;

SELECT *
FROM emp;

--사원번호가 9999인 사원의 소속 부서와 담당업무를 SMITH사원의 부서, 업무로 업데이트
UPDATE emp SET deptno = (SELECT deptno FROM emp WHERE ename = 'SMITH'),
               job = (SELECT job FROM emp WHERE ename = 'SMITH')
WHERE empno = 9999;

commit;

SELECT *
FROM emp
WHERE empno = 9999;

--DELETE : 조건에 해당하는 ★ROW를 삭제★
--컬럼의 값을 삭제??(NULL)값으로 변경하려면 -->UPDATE해야함

--DELETE 테이블명
--[WHERE 조건]

--UPDATE쿼리와 마찬가지로 DELETE 쿼리 실행전에는 해당 테이블을 WHERE조건을 동일하게 하여
--SELECT를 실행, 삭제될 ROW를 먼저 확인해보자

--emp테이블에 존재하는 사원번호 9999인 사원을 삭제
DELETE emp
WHERE empno = 9999;
commit;
-- DELETE emp; <- emp 테이블 전체 삭제

SELECT *
FROM emp
WHERE empno = 9999;

--매니저가 7698인 모든 사원을 삭제
--서브쿼리를 사용
SELECT empno
FROM emp
WHERE mgr = 7698;


DELETE emp
WHERE empno IN( SELECT empno
                FROM emp
                WHERE mgr = 7698);
rollback;
--위 쿼리는 아래 쿼리와 동일함                
DELETE emp WHERE mgr = 7698;                

SELECT *
FROM emp;

--ISOLATION LEVEL2
--선행 트랜젝션에서 읽은 데이터
--(FOR UPDATE)를 수정, 삭제 하지못함

UPDATE dept SET dname = 'ddit'
WHERE deptno = 99;

--BOSTON 40
SELECT *
FROM dept
WHERE deptno = 40
FOR UPDATE;

SELECT *
FROM dept;
--다른 트랜잭션에서 수정을 못하기 때문에
--현 트랜잭션에서 해달 ROW는 항상 동일한 결과값으로 조히 할 수 있다.
SELECT *
FROM dept;
--하지만 후행 트랜잭션에서 신규 데이터 입력후
-- commit을 하면 현 트랜잭션에서 조회가 된다 (phantom read)

--ISOLATION LEVEL3
--SERIALIZABLE READ
--트랜잭션의 데이터 조회 기준이 트랜잭션 시작 시점으로 맞춰진다
-- 즉 후행 트랜잭션에서 데이터를 신규 입력, 수정, 삭제 후 commit을 하더라도
--선행 트랜잭션에서는 해당 데이터를 보지 않는다.

--트랜잭션 레벨 수정(serializable read)
SET TRANSACTION isolation LEVEL SERIALIZABLE;

DELETE dept WHERE deptno = 99;
SELECT *
FROM dept;

--dept 테이블에 시노님을 생성하여 (d)
SELECT *
FROM dept;

--DDL : TABLE 생성
--CREATE TABLE [사용자명.] 테이블명(
--            컬럼명1 컬럼타입1,
--            컬럼명1 컬럼타입2, ....
--            컬럼명N 컬럼타입N);
-- ranger_no NUMBER             : 레인저 번호
-- ranger_name VARCHAR2(50)     : 레인저 이름
-- reg_dt DATE                  : 레인저 등록일자
--테이블 생성 DDL : Data Defination Language(데이터 정의어)
-- DDL은 rollback이 없다( 자동커밋 되므로 rollback을 할 수 없다)
CREATE TABLE ranger(
            ranger_no NUMBER,
            ranger_name VARCHAR2(50),
            reg_dt DATE);
rollback; -- 롤백 안됨.   DDL 문장은 rollback 처리 불가!!!!
DESC ranger;

SELECT *
FROM user_tables
WHERE table_name = 'RANGER';
--WHERE table_name = 'ranger'; <- 오라클에서는 객체 생성시 소문자로 생성하더라도
-- 내부적으로는 대문자로 관리한다.

INSERT INTO ranger VALUES(1, 'brown', sysdate);
--데이터가 조회되는 것을 확인 했음
SELECT * 
FROM ranger;

--DML문은 DDL과 다르게 rollback이 가능하다
rollback;

--rollback을 했기 때문에 DML문장이 취소된다
SELECT *
FROM ranger;

--DATE 타입에서 필드 추출하기
--EXTRACT(필드명 FROM 컬럼/expression)
SELECT TO_CHAR(sysdate, 'yyyy')yyyy,
       TO_CHAR(sysdate, 'mm') mm,
       EXTRACT(year FROM SYSDATE)ex_yyyy,
       EXTRACT(month FROM SYSDATE)ex_mm,
       EXTRACT(day FROM SYSDATE)ex_day
FROM dual;

--테이블 생성시 컬럼 레벨 제약조건 생성
CREATE TABLE dpet_test(
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13));
    
DROP TABLE dpet_test;    

CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13));
    
    DESC dept_test;
--dept_test 테이블의 dpetno 컬럼에 PRIMARY KEY 제약조건이 있기 때문에
--deptno가 동일한데이터를 입력하거나 수정 할 수 없다
--최초 데이터이므로 입력성공
INSERT INTO dept_test VALUES(99, 'ddit','datjeon');

--dept_test 데이터에 eeptno가 99번인 데이터가 있으므로
--primary key 제약조건에 의해 입력 될 수 없다
--오류 보고 -
--ORA-00001: unique constraint (SJSJ.SYS_C007106) violated <- 제약조건때문에 오류
-- SYS_C007106 제약조건을 어떤 제약 조건인지 판단하기 힘드므로
--제약조건에 이름을 코딩 룰에 의해 붙여 주는 편이 유지보수시 편하다.
INSERT INTO dept_test VALUES(99, '대덕','대전');

--테이블 삭제후 제약조건 이름을 추가하여 재생성
--primary key : pk_테이블명
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2) CONSTRAINT pk_dept_test PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13));

INSERT INTO dept_test VALUES(99, 'ddit','datjeon');
INSERT INTO dept_test VALUES(99, '대덕','대전');
--오류 보고 -
--ORA-00001: unique constraint (SJSJ.PK_DEPT_TEST) violated <- pk_dept_test라는 제약조건에 이름을 붙였기 때문에 알아보기 쉬움
