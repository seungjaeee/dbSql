SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 10;

SELECT ROWNUM, a.*
FROM
(SELECT ROWNUM rn, empno, ename
FROM emp) a
WHERE rn BETWEEN 11 AND 14;

--emp 테이블에서 ename컬럼 기준으로 오름차순 정렬 했을때 11~14번째 행의 데이터만 조회하는 쿼리를 작성하세요
SELECT *
FROM
(SELECT ROWNUM rn, a.*
FROM 
(SELECT empno, ename
FROM emp
ORDER BY ename)a)
WHERE rn BETWEEN 11 AND 14;

SELECT *
FROM
(SELECT ROWNUM rn, a.*
FROM
(SELECT empno, ename
FROM emp
ORDER BY ename)a)
WHERE rn BETWEEN 11 AND 14;

SELECT rn, empno, ename
FROM
(SELECT ROWNUM rn, a.*
FROM
(SELECT empno, ename
FROM emp
ORDER BY ename)a)
WHERE rn BETWEEN 11 AND 14;

-- DUAL 테이블 : sys 계정에 있는 누구나 사용가능한 테이블이며 
-- 데이터는 한행만 존재하고 컬럼(dummy)도 하나 존재 ('X')

SELECT *
FROM dual;

--SINGLE ROW FUNCTION : 행당 한번의 FUNCTION이 실행
-- 1개의 행 INPUT -> 1개의 행으로 OUTPUT (COLUMN)
-- 'Hello, World'
--dual 테이블에는 데이터가 하나의 행만 존재한다. 결과도 하나의 행으로 나온다
SELECT LOWER('Hello, World') low, UPPER('Hello, World') upper, 
       INITCAP('Hello, World') INIT
FROM dual;

--emp테이블에는 총 14건의 데이터(직원)가 존재 (14개의 행)
--아래쿼리는 결과도 14개의 행
SELECT LOWER('Hello, World') low, UPPER('Hello, World') upper, 
       INITCAP('Hello, World') INIT
FROM emp;

SELECT empno, LOWER (ename) low_enm
FROM emp
WHERE ename = UPPER('smith'); --직원 이름이 smith인 사람을 조회 하려면 대문자/소문자 ?

SELECT UPPER('smith')
FROM dual;

--테이블 컬럼을 가공해도 동일한 결과를 얻을 수 있지만
--테이블 컬럼 보다는 상수쪽을 가공하는 것이 속도면에서 유리
--해당 컬럼에 인덱스가 존재하더라도 함수를 적용하게되면 값이 달라지게 되어
--인덱스를 활용 할 수 없게 된다
--예외 : FBI(Function Based Index)
SELECT empno, LOWER(ename) low_enm
FROM emp
WHERE LOWER(ename) = 'smith'; -- 안쓰는게 좋다

--HELLO
-- ','
-- HELLO, WORLD (위 3가지 문자열 상수를 이용, CONCAT 함수를 사용하여 문자열 결합)
SELECT CONCAT(CONCAT('HELLO', ','), 'WORLD') c1,
       'HELLO' || ',' || 'WORLD' c2,
       --시작인덱스는 1부터, 종료인덱스는 종료인덱스 문자열까지 포함한다. 1은 시작인덱스 5는 종료인덱스 5까지 포함함.
       SUBSTR('HELLO, WORLD', 1, 5)s1, -- SUBSTR(문자열, 시작인덱스, 종료인덱스) 
       --INSTR : 문자열에 특정 문자열이 존재하는지, 존재할 경우 문자의 인덱스를 리턴
       INSTR('HELLO, WORLD', 'O')i1, -- 5, 9
       --'HELLO, WORLD' 문자열의 6번째 인덱스 이후에 등장하는 'O'문자열의 인덱스 리턴
       INSTR('HELLO, WORLD', 'O', 6)i2, -- 5,9중에 9가나옴 문자열의 특정 인덱스 이후부터 검색하도록 옵션(6번째 자리 이후 검색)
        INSTR('HELLO, WORLD', 'O', INSTR('HELLO, WORLD', 'O') +1) i3,
       
       --L/RPAD 특정 문자열의 왼쪽/오른쪽에 설정한 문자열 길이보다 부족한 만큼 문자열을 채워 넣는다
       LPAD('HELLO, WORLD', 15, '*')L1,
       LPAD('HELLO, WORLD', 15)L2, -- DEFAULT 채움 문자는 공백이다
       RPAD('HELLO, WORLD', 15, '*')R1,
       
       --REPLACE(대상문자열, 검색 문자열, 변경할 문자열)
       --대상문자열에서 검색 문자열을 변경할 문자열로 치환
       REPLACE('HELLO, WORLD', 'HELLO', 'hello') rep1, --hello, WORLD
       
       --TRIM은 문자열 앞, 뒤의 공백을 제거
       '    HELLO, WORLD    ' before_trim,
       TRIM('    HELLO, WORLD    ') after_trim,
       TRIM('H' FROM 'HELLO, WORLD') after_trim2 -- HELLO, WORLD 라는 곳으로부터 H를 제거해라.
FROM dept;

--숫자 조작함수
--ROUND : 반올림 - ROUND(숫자, 반올림 자리)
--TRUNC : 절삭 - TRUNC(숫자, 절삭 자리)
--MOD : 나머지 연산 MOD(피제수, 제수 // MOD(5, 2) = 1 

SELECT ROUND(105.54, 1) r1, --결과 : 105.5(반올림결과가 소숫점 한자리까지 나오도록(소숫점 둘째자리에서 반올림))
       ROUND(105.55, 1) r2, --결과 : 105.6
       ROUND(105.55, 0) r3, --결과 : 106 (소숫점 첫번째 자리에서 반올림) (정수가 됨)
       ROUND(105.55, -1) r3 --결과 : 110( 정수 첫번째 자리에서 반올림)
FROM dual;

SELECT TRUNC(105.54, 1) t1, --절삭 결과가 소수점 한자리까지 나오도록(소숫점 둘째자리에서 절삭) (반내림)
       TRUNC(105.55, 1) t2,
       TRUNC(105.55, 0) t3,
       TRUNC(105.55, -1) t4
FROM dual;

--MOD(피제수, 제수) 피제수를 제수로 나눈 나머지의 값
--MOD(M, 2) 의 결과 종류 : 0, 1 (0부터 제수-1 까지)
SELECT MOD(5, 2) M1 --결과값 : 1 (5/2 = 몫이 2, [나머지가 1])
FROM dual;

--emp 테이블의 sal 컬럼을 1000으로 나눴을때 사원별 나머지 값을 조회 하는 sql 작성
--ename, sal, sal/1000 했을때의 몫, sal/1000 했을때의 나머지
SELECT ename 이름, TRUNC(sal/1000, 0) 몫, MOD(sal, 1000) 나머지,
       TRUNC(sal/1000, 0) * 1000 + MOD(sal, 1000) 급여
FROM emp;

--DATE : 년월일, 시간, 분, 초 
SELECT ename, hiredate, TO_CHAR(hiredate, 'YYYY-MM-DD hh24-mi-ss') z --YYYY/MM/DD
FROM emp;           -- 도구 - 환경설정 - 데이터베이스 - NLS 에서 날짜형식 변경가능

--SYSDATE : 서버의 현재 DATE를 리턴하는 내장함수, 특별한 인자가 없다
--DATE 연산  DATE + 정수N = N만큼 일자가더해진다
--DATE 연산에 있어서 정수는 일자
--하루는 24시간
--DATE 타입에 시간을 더할수도 있다. 1시간 = 1/24
SELECT TO_CHAR(SYSDATE + 5, 'YYYY-MM-DD hh24:mi:ss') AFTER5_DAYS, -- 5일 뒤 현재시간
       TO_CHAR(SYSDATE + 5/24, 'YYYY-MM-DD hh24:mi:ss') AFTER5_HOURS, -- 5시간 뒤 현재시간
       TO_CHAR(SYSDATE + 5/24/60, 'YYYY-MM-DD hh24:mi:ss') AFTER5_MIN
FROM dual;

SELECT TO_DATE('2019-12-31', 'YYYY-MM-DD') LAST_DAY,
       TO_DATE('2019-12-31', 'YYYY-MM-DD') -5 LAST_DAY_BEFORE5,
       SYSDATE NOW,
       SYSDATE -3 NOW_BEFORE3
FROM dual;

--YYYY, MM, DD, D(요일을 숫자로 -> 일요일 1, 월요일 2, 화요일 3 ... 토요일 7
--IW(주차 1~53), HH, MI, SS
SELECT TO_CHAR(SYSDATE, 'YYYY') YYYY, -- 현재 년도
       TO_CHAR(SYSDATE, 'MM') MM, --현재 월
       TO_CHAR(SYSDATE, 'DD') DD, --현재 일
       TO_CHAR(SYSDATE, 'mi') mi, --현재 분
       TO_CHAR(SYSDATE, 'ss') ss, -- 현재 초
       TO_CHAR(SYSDATE, 'D') D, --현재 요일(주간일자1~7)
       TO_CHAR(SYSDATE, 'IW') IW, --현재 일자의 주차(해당주의 목요일을 주차의 기준으로)
       --2019년 12월 31일은 몇주차가 나오는가?
       TO_DATE('20191231', 'YYYYMMDD'),
       TO_CHAR(TO_DATE('20191231', 'YYYYMMDD'), 'IW') IW_20191231 -- 1주차
FROM dual;

--오늘날짜를 년월일 포맷으로 작성
--오늘날짜를 년월일 시간-분-초
--오늘날짜를 년월일 일-월-년
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') DT_DASH,
       TO_CHAR(SYSDATE, 'YYYY-MM-DD hh24:mi:ss') dt_dasg_with_time,
       TO_CHAR(SYSDATE, 'DD-MM-YYYY') dt_dd_mm_YYYY
FROM dual;

--DATE 타입의 ROUND, TRUNC 적용
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD hh24:mi:ss') now,
        --MM에서 반올림 (11월 -> 1년)
       TO_CHAR(ROUND(SYSDATE, 'YYYY'), 'YYYY-MM-DD hh24:mi:ss') now_YYYY,
       
       --DD에서 반올림 (25일 -> 1개월)
       TO_CHAR(ROUND(SYSDATE, 'MM'), 'YYYY-MM-DD hh24:mi:ss') now_MM,
       --시간에서 반올림
       TO_CHAR(ROUND(SYSDATE, 'DD'), 'YYYY-MM-DD hh24:mi:ss') now_DD
FROM dual;

SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD hh24:mi:ss') now,
        --MM에서 절삭 (11월 -> 1월)
       TO_CHAR(TRUNC(SYSDATE, 'YYYY'), 'YYYY-MM-DD hh24:mi:ss') now_YYYY,
       
       --DD에서 절삭
       TO_CHAR(TRUNC(SYSDATE, 'MM'), 'YYYY-MM-DD hh24:mi:ss') now_MM,
       --시간에서 절삭
       TO_CHAR(TRUNC(SYSDATE, 'DD'), 'YYYY-MM-DD hh24:mi:ss') now_DD
FROM dual;


--날짜 조작 함수
--MONTHS_BETWEEN(date1, date2) : date2와 date1 사이의 개월 수
--ADD_MONTHS(date, 가감할 개월수) : date에서 특정 개월수를 더하거나 뺀 날짜
--NEXT_DAY(date, weekday(1~7)) : date이후 첫번째 weekday 날짜
--LAST_DAY(date) : date가 속한 월의 마지막 날짜

--MONTHS_BETWEEN(date1, date2)
SELECT MONTHS_BETWEEN(TO_DATE('2019-11-25', 'yyyy-mm-dd'),  
                      TO_DATE('2019-03-31', 'yyyy-mm-dd')) m_bet,
        TO_DATE('2019-11-25', 'yyyy-mm-dd') -  TO_DATE('2019-03-31', 'yyyy-mm-dd') d_m --두 날짜 사이의 일자 수
FROM dual;

--★★★ADD_MONTHS(date, number(+,-) )★★★
SELECT ADD_MONTHS (TO_DATE('20191125', 'yyyymmdd'), 5) NOW_AFTER5M,
       ADD_MONTHS (TO_DATE('20191125', 'yyyymmdd'), -5) NOW_BEFORE5M,
       SYSDATE + 100 --100일 뒤의 날짜 (월 개념 3-31, 2-28/29
FROM dual;

--NEXT_DAY(date, weekday number( 1~7 ))
SELECT NEXT_DAY(SYSDATE, 7) -- 오늘 날짜(2019/11/25)일 이후 등장하는 첫번째 토요일
FROM dual;
--★★★★★