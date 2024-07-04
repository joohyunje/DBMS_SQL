-- PLAYER 테이블에서 키가 NULL인 선수들의 키를 170으로 변경하여 평균 조회

SELECT AVG(H) 
FROM (
	SELECT NVL(HEIGHT, 170) H
	FROM PLAYER
);

SELECT AVG(NVL(HEIGHT, 170))
FROM PLAYER p ;
	
SELECT * FROM PLAYER p ;

-- AVG함수를 쓰지 않고 PLAYER 테이블에서 선수들의 평균 키 구하기
-- 단, NULL 은 미포함.

SELECT (SELECT SUM(HEIGHT) FROM PLAYER) / COUNT()
FROM PLAYER.

SELECT SUM(H) / COUNT(H) 평균키
FROM (
	SELECT NVL(HEIGHT, 170) H
	FROM PLAYER
);

SELECT SUM(HEIGHT) / COUNT(HEIGHT) "평균 키"
FROM PLAYER p;

/*
  DEPT 테이블의 LOC별 평균 급여를 반올림한 값과 각 LOC별 SAL합을 조회
 */
SELECT LOC, ROUND(AVG(SAL),2), SUM(SAL)
FROM DEPT D JOIN EMP E
ON D.DEPTNO = E.DEPTNO
GROUP BY LOC;

/*
  PLAYER 테이블에서 팀별 최대 몸무게인 선수 전체 정보 검색
 */
SELECT * FROM PLAYER
WHERE (TEAM_ID, WEIGHT) IN (
	SELECT TEAM_ID, MAX(WEIGHT) 
	FROM PLAYER
	GROUP BY TEAM_ID 
);

SELECT *
FROM
(
	SELECT TEAM_ID, MAX(WEIGHT) WEIGHT  
	FROM PLAYER
	GROUP BY TEAM_ID
) M JOIN PLAYER p 
ON M.TEAM_ID = P.TEAM_ID
AND M.WEIGHT = P.WEIGHT
ORDER BY M.TEAM_ID;
/*
  EMP테이블에서 HIREDATE가 FORD의 입사년도와 같은 사원 전체 정보 조회
 */
SELECT *
FROM EMP e
WHERE TO_CHAR(HIREDATE, 'YYYY') = 
			(SELECT TO_CHAR(HIREDATE,'YYYY')
			FROM EMP
			WHERE ENAME = 'FORD'
		);

-- 조인
SELECT E1.* 
FROM EMP E1 JOIN
(
   SELECT HIREDATE
   FROM EMP
   WHERE ENAME = 'FORD'
) E2
ON TO_CHAR(E1.HIREDATE, 'YYYY') = TO_CHAR(E2.HIREDATE, 'YYYY');
--===============================================================================================
-- 형변환 함수
-- TO_CHAR()

SELECT TO_CHAR(SYSDATE, 'YYYY/MM/DD')
FROM DUAL;

SELECT TO_CHAR(SYSDATE, 'YYYY"년" MM"월" DD"일" HH24"시" MI"분" SS"초"')
FROM DUAL;

-- 숫자에 콤마찍기
SELECT 1000000000000
FROM DUAL ;

SELECT TO_CHAR(1000000000000, 'FM9,999,999,999,999,999,999,999') 숫자
FROM DUAL;
--===================================================================
-- EMP 테이블에서 DEPTNO 가 30 또는 10인 데이터를 조회하기
-- 두 테이블을 UNION 으로 연결한다.
SELECT * FROM EMP
WHERE DEPTNO = 30
UNION
SELECT * FROM EMP
WHERE DEPTNO = 10;

-- UNION 으로 다른 테이블의 값들도 같이 조회할 수 있을까??
-- 놉
-- 컬럼의 수가 달라서 에러!
SELECT * FROM EMP e 
UNION
SELECT * FROM DEPT d;

-- 자료형이 달라서 에러!
SELECT ENAME, HIREDATE, SAL
FROM EMP
UNION
SELECT * FROM DEPT d;

-- 나온다!
SELECT EMPNO, ENAME, JOB
FROM EMP
UNION
SELECT * FROM DEPT d;

-- 가상의 테이블이라는 것을 인지!
SELECT COUNT(*)
FROM
(
   SELECT EMPNO, ENAME, JOB
   FROM EMP
   UNION
   SELECT * FROM DEPT d
);

SELECT EMPNO, ENAME, JOB
FROM EMP
UNION
SELECT * FROM
(
   SELECT * FROM DEPT d
   ORDER BY DEPTNO
);
--==================================================================================================
-- VIEW
-- PLAYER 테이블에서 나이 컬럼을 추가한 뷰 만들기

SELECT * FROM PLAYER p ;

CREATE VIEW VIEW_PLAYER AS
SELECT P.*, ROUND(SYSDATE - BIRTH_DATE)/365 AGE FROM PLAYER P; 

-- 매뉴얼 커밋 하고! 실습!
SELECT * FROM VIEW_PLAYER
WHERE PLAYER_NAME = '류호근';

INSERT INTO HR.VIEW_PLAYER
(PLAYER_ID, PLAYER_NAME, TEAM_ID, E_PLAYER_NAME, NICKNAME, JOIN_YYYY, "POSITION", BACK_NO, NATION, BIRTH_DATE, SOLAR, HEIGHT, WEIGHT)
VALUES('AB', '류호근', 'K01', 'DD', 'DD', 'DD', 'DD', 3, 'DD', SYSDATE, 'D', 0, 0);

SELECT * FROM PLAYER
WHERE PLAYER_NAME = '류호근';
-- 오토커밋으로 다시 컴백!

-- EMP 테이블에서 사원의 이름과 그 사윈의 매니저 이름이 있는 VIEW 만들기
-- 사원번호와 매니저 번호도 같이 조회

--CREATE VIEW 
SELECT  E1.ENAME "사원 이름",E1.EMPNO "사원번호", E2.ENAME "사원의 매니저", E2.EMPNO "매니저 번호"
FROM EMP E1 JOIN EMP E2
ON E1.MGR = E2.EMPNO;










