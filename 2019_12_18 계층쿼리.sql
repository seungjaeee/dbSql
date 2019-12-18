

SELECT dept_h.*, LEVEL, LPAD(' ', (LEVEL -1)*3) || deptnm
FROM dept_h
START WITH deptcd='dept0' -- 시작점은 deptcd = 'dept0' --> XX회사(최상위조직)
CONNECT BY PRIOR deptcd = p_deptcd --PRIOR : 이미 읽은것
ORDER BY level;

SELECT LPAD('XX회사', 15, '*'),
       LPAD('XX회사', 15)
FROM dual;


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
*/
SELECT LEVEL, deptcd, LPAD(' ',(LEVEL-1)*3)||deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptnm = '정보시스템부'
CONNECT BY PRIOR deptcd = p_deptcd;

SELECT *
FROM dept_h;
--디자인팀[dept0_00_0)을 기준으로 상향식 계층쿼리 작성
--자기 부서의 부모 부서와 연결을 한다
SELECT deptcd, LPAD(' ',(LEVEL -1)*3)||deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_00_0'
--CONNECT BY PRIOR p_deptcd = deptcd
CONNECT BY deptcd = PRIOR p_deptcd;


SELECT LPAD(' ',(LEVEL-1)*3)||s_id s_id, value
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id;


SELECT LPAD(' ',(LEVEL-1)*4)||org_cd org_cd, no_emp
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;

SELECT *
FROM no_emp;

-- pruning branch (가지치기)
-- 계층 쿼리의 실행순서
-- FROM -> START WITH ~ CONNECT BY -> WHERE
-- 조건을 CONNECT BY 절에 기술한 경우
--  . 조건에 따라 다음 ROW로 연결이 안되고 종료
-- 조건을 WHERE 절에 기술한 경우
--  . START WITH ~ CONNECT BY 절에 의해 계층형으로 나온 결과에
--  WHERE절에 기술한 결과 값에 해당하는 데이터만 표현

--최상위 노드에서 하향식으로 탐색
--CONNECT BY 절에 deptnm != '정보기획부' 조건을 기술한 경우
SELECT *
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd AND deptnm != '정보기획부';

--WHERE절에 deptnm != '정보기획부' 조건을 기술한 경우
-- 계층쿼리를 실행하고나서 최종 결과에 WHERE 절 조건을 적용
SELECT *
FROM dept_h
WHERE deptnm != '정보기획부'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

--계층 쿼리에서 사용 가능한 특수 함수
-- CONNECT_BY_ROOT(col) 가장 최상위 row의 col 정보 값 조회
-- SYS_CONNECT_BY_PATH(col, 구분자) : 최상위 row에서 현재 row까지 col값을
-- 구분자로 연결해준 문자열 (EX : XX회사 - 디자인부-디자인팀)
-- CONNECT_BY_ISLEAF : 해당 ROW가 마지막 노드인지(leaf Node)
-- leaf node : 1, node : 0
SELECT deptcd, LPAD(' ', (LEVEL-1)*4) || deptnm deptnm,
       CONNECT_BY_ROOT(deptnm) c_root,
       LTRIM(SYS_CONNECT_BY_PATH(deptnm,'-'),'-') sys_path,
       CONNECT_BY_ISLEAF isleaf
FROM dept_h
WHERE deptnm != '정보기획부'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

--h6  응용 sql pt 87
SELECT seq, LPAD(' ',(LEVEL-1)*3)||title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq;

--h7 가장 최신글이 먼저 나오도록 정렬 (잘못된 방법)
SELECT seq, LPAD(' ',(LEVEL-1)*3)||title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq 
ORDER BY seq DESC;

--계층 구조를 유지한 상태에서 정렬 하는 방법 ( ORDER SIBLINGS BY)
SELECT seq, LPAD(' ',(LEVEL-1)*3)||title title        
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq 
ORDER SIBLINGS BY seq DESC;

SELECT *
FROM board_test;







