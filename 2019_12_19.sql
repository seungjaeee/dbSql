SELECT seq,CONNECT_BY_ROOT(seq)a, LPAD(' ',(LEVEL-1)*3)||title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq 
ORDER BY a DESC,seq ;

--사원이름, 사원번호, 전체직원건수  -- 원하는 결과 안나옴.
SELECT ename, empno, COUNT(*), sum(sal)
FROM emp
GROUP BY ename, empno;


--응용 sql pt 99
SELECT a.ename, a.sal, a.deptno, b.rn
FROM
(SELECT ename, sal, deptno, ROWNUM j_rn
FROM
(SELECT ename, sal, deptno
FROM emp
ORDER BY deptno, sal DESC)) a,

(SELECT rn, ROWNUM j_rn
FROM
(SELECT b.*,a.rn
FROM
(SELECT ROWNUM rn
FROM dual
CONNECT BY LEVEL <= (SELECT COUNT(*) FROM emp))a,

(SELECT deptno,count(*)cnt
FROM emp
GROUP BY deptno)b
WHERE b.cnt >= a.rn
ORDER BY b.deptno, a.rn))b
WHERE a.j_rn = b.j_rn;

--위에 긴 쿼리를 분석함수로
SELECT ename, sal, deptno,
    RANK() OVER(PARTITION BY deptno ORDER BY sal ) rank,
    DENSE_RANK() OVER(PARTITION BY deptno ORDER BY sal ) dense_rank,
    ROW_NUMBER() OVER(PARTITION BY deptno ORDER BY sal ) row_rank 
FROM emp;

SELECT empno, ename, sal, deptno,
    RANK() OVER(ORDER BY sal DESC,empno) sal_rank,
    DENSE_RANK() OVER(ORDER BY sal DESC,empno) sal_dense_rank,
    ROW_NUMBER() OVER(ORDER BY sal DESC,empno) sal_row_number
FROM emp;




SELECT a.empno,a.ename,a.deptno,b.cnt
FROM
(SELECT empno,ename,deptno
FROM emp
)a,

(SELECT deptno,COUNT(*)cnt
FROM emp
GROUP BY deptno)b
WHERE a.deptno = b.deptno
ORDER BY cnt;

SELECT a.empno,a.ename,a.deptno,b.cnt
FROM
(SELECT empno, ename, deptno
FROM emp)a,

(SELECT deptno,COUNT(*)cnt
FROM emp
GROUP BY deptno)b
WHERE a.deptno = b.deptno;

--사원번호, 사원이름, 부서번호, 부서의 직원수
SELECT empno, ename, deptno, COUNT(*) OVER(PARTITION BY deptno)cnt
FROM emp;

SELECT empno, ename, sal, deptno, ROUND(avg(sal) OVER(PARTITION BY deptno),2) sal_avg
FROM emp;

SELECT a.empno,a.ename,a.sal,a.deptno,b.avg
FROM
(SELECT empno, ename, sal, deptno
FROM emp)a,

(SELECT deptno, ROUND(avg(sal),2)avg
FROM emp
GROUP BY deptno)b
WHERE a.deptno = b.deptno
ORDER BY a.deptno;

--응용 sql pt 112 분석함수 사용
SELECT empno, ename, sal, deptno, MAX(sal) OVER(PARTITION BY deptno) max_sal
FROM emp;

--기존에 배웠던 방식
SELECT a.empno,a.ename,a.sal,a.deptno,max_sal
FROM
(SELECT empno, ename, sal, deptno
FROM emp)a,

(SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno)b
WHERE a.deptno = b.deptno
ORDER BY deptno;

--응용 sql pt 113 분석함수 사용
SELECT empno,ename,sal,deptno, MIN(sal) OVER(PARTITION BY deptno) min_sal
FROM emp;

--기존에 배웠던 방식
SELECT a.empno, a.ename, a.sal, a.deptno, b.min_sal
FROM
(SELECT empno, ename, sal, deptno
FROM emp)a,

(SELECT deptno, MIN(sal) min_sal
FROM emp
GROUP BY deptno)b
WHERE a.deptno = b.deptno
ORDER BY deptno;

SELECT empno, ename, hiredate, sal
FROM emp
ORDER BY sal DESC, hiredate;

--pt 115
SELECT empno, ename, hiredate, sal, LEAD(sal) OVER(ORDER BY sal DESC,hiredate) lead_sal
FROM emp;
--pt 116
SELECT empno, ename, hiredate, sal, LAG(sal) OVER(ORDER BY sal DESC,hiredate) lag_sal
FROM emp;

SELECT empno, ename, hiredate, job, sal, LAG(sal) OVER(PARTITION BY job ORDER BY sal DESC, hiredate) lag_sal
FROM emp;

SELECT a.empno,a.ename,a.sal,ROWNUM j_rn
FROM
(SELECT a.empno, a.ename, a.sal, ROWNUM rn
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal,empno)a)a,

SELECT ROWNUM j_rn
FROM
(SELECT sal,ROWNUM rn
FROM emp)b;










