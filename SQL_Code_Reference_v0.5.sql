/***********************************************************
	-- SQL Code Reference 
	-- v0.1
	-- 2017. 07. 09.   박민수
***********************************************************/


-- *********************************************************
-- SELECT 절 순서 
-- *********************************************************

SELECT      -- 가져올 컬럼이나 수식
FROM        -- 데이터를 가져올 테이블
WHERE       -- 행 레벨 필터링
GROUP BY    -- 그룹 지정
HAVING      -- 그룹 레벨 필터링
ORDER BY    -- 정렬 순서

-- ## 계산 필드로 서브쿼리 사용하기

SELECT 
		CUST_NAME
	,	CUST_STATE
	,	( SELECT COUNT(*)
			FROM ORDERS
			WHERE ORDERS.CUST_ID = CUSTOMERS.CUST_ID) AS ORDERS
	FROM CUSTOMERS
	ORDER BY CUST_NAME;

-- *************************************************************
-- 테이블 JOIN 1 -- 동등조인(EQUI-JOIN) 문법 (VS 내부조인_INNER-JOIN 문법) 
-- *************************************************************	

--## 동등조인 문법 사용하기
SELECT VEND_NAME, PROD_NAME, PROD_PRICE
	FROM VENDORS, PRODUCTS
	WHERE VENDERS.VEND_ID = PRODUCTS.VEND_ID;
	
-- ## 3개 테이블을 동등조인으로 결합
-- PRODUCTS 테이블을 구동 테이블로 사용하여 결합 

SELECT PROD_NAME, VEND_NAME, PROD_PRICE, QUANTITY
	FROM ORDERITEMS, PRODUCTS, VENDORS
	WHERE PRODUCTS.VEND_ID = VENDORS.VEND_ID
	      AND PRODUCTS.PROD_ID = ORDERITEMS.PROD_ID
		  AND ORDER_NUM = 20007;
		  
-- ## 3개 테이블을 내부조인으로 결합

SELECT A.COL_A, B.COL_B, C.COL_C
	FROM TABLE_A AS A
			INNER JOIN
		 TABLE_B AS B
		    ON A.COL_A = B.COL_B
			INNER JOIN 
		 TABLE_C AS C 
		    ON A.COL_A = C.COL_C
			AND B.COL_B = C.COL_C  -- 테이블 B와 C는 불필요한 결합 조건이어야 함
			                       -- 의도하지 않은 크로스 결합을 회피 
								   
-- *************************************************************
-- 테이블 JOIN 2 -- SELF-JOIN 
-- *************************************************************

-- SELECT 문에서 같은 테이블을 두 번 이상 참고할 때

-- 1. 서브쿼리를 사용
SELECT CUST_ID, COMPANY_NAME, CUST_CONTACT
		FROM CUSTOMERS
		WHERE COMPANY_NAME = ( SELECT COMPANY_NAME
							     FROM CUSTOMERS
								 WHERE COMPANY_NAME = 'JIM JONES');
								 
	-- JIM JONES 가 속한 회사가 필터링 조건으로 걸려 그 회사의 CUST_CONTACT 가 모두 선택
								 
-- 2. 셀프조인 사용 
SELECT A.CUST_ID, A.COMPANY_NAME, A.CUST_CONTACT
		FROM CUSTOMERS AS A, CUSTOMERS AS B
		WHERE A.COMPANY_NAME = B.COMPANY_NAME
		      AND B.CUST_CONTACT = 'JIM JONES' ;
	
	-- 속도면에서 셀프조인이 훨씬 빠름
	
-- *************************************************************
-- 테이블 JOIN 3 -- 기타 
-- *************************************************************

-- ## 자연조인
-- CUSTOMERS 테이블을 와일드 카드로 사용하고, 다른 테이블은 가져올 컬럼을 명시하여,
-- 중복컬럼이 없이 가져오는 것 (모든 내부조인은 자연조인) 
SELECT C.*, O.ORDER_NUM, O.ORDER_DATE,
       OI.PROD_ID, OI.QUANTITY, OI.ITEM_PRICE
		FROM CUSTOMERS AS C, ORDERS AS O, ORDERITEMS AS OI
		WHERE C.CUST_ID = O.CUST_ID
		      AND OI.ORDER_NUM = O.ORDER_NUM 
			  AND PROD_ID = 'RGAN01';
			  
-- 내부조인 : 두 테이블과 관련 있는 행만 가져옴
-- 외부조인 : 한쪽 테이블은 모든 행을 가져오고, 나머지는 관련있는 행만 가져옴
-- FULL OUTER JOIN : 두 테이블에서 모든 행을 가져오고 관련행은 연결함


-- *************************************************************
-- 서브쿼리 사용_1
-- *************************************************************
	-- 서브쿼리 사용 기본
	-- 고객의 최소 순번 값을 저장하는 서브쿼리 (R2) 를 만들고
	-- 기존의 Receipts 테이블과 결합함
	-- MIN, MAX 등 집계함수와, 다른 변수를 결합할 때
	
SELECT CUST_ID, SEQ, PRICE 
		FROM RECEIPTS
		WHERE CUST_ID IN ( SELECT CUST_ID, MIN(SEQ) AS MIN_SEQ 
									FROM RECEIPTS
									GROUP BY CUST_ID )	
	
SELECT R1.CUST_ID, R1.SEQ, R1.PRICE
		FROM RECEIPTS AS R1
				INNER JOIN
			 (SELECT CUST_ID, MIN(SEQ) AS MIN_SEQ
					 FROM RECEIPTS 
					 GROUP BY CUST_ID) AS R2
				ON R1.CUST_ID = R2.CUST_ID AND
				   R1.SEQ = R2.MIN_SEQ ;
				   

-- *************************************************************
-- 서브쿼리 사용_2 : 결합과 집약의 순서
-- *************************************************************				   

--## 1. 집약을 먼저 수행

SELECT C.CO_CD, C.DISTRICT, CSUM.SUM_EMP
		FROM COMPANIES AS C 
				INNER JOIN 
			(SELECT CO_CD, SUM(EMP_NBR) AS SUM_EMP
					 FROM SHOPS
					 WHERE MAIN_FLG = 'Y'
					 GROUP BY CO_CD ) AS CSUM
				ON C.CO_CD = CSUM.CO_CD ;
				
--## 2. 결합을 먼저 수행

SELECT C.CO_CD, MAX(C.DISTRICT)
	,  SUM(EMP_NBR) AS SUM_EMP 
		FROM COMPANIES AS C
				INNER JOIN
			 SHOPS AS S 
			    ON C.CO_CD = S.CO_CD 
		WHERE MAIN_FLG = 'Y'
		GROUP BY C.CO_CD;

	-- 서브쿼리는 복잡한 문제를 분할할 수 있는 편리한 도구지만, 결합을 늘리는 성능 악화를 일으킬 수 있음
	-- SQL 성능을 결정하는 요인은 I/O 가 절대적
	-- 서브쿼리와 결합을 윈도우 함수로 대체하면 성능을 개선할 가능성이 있음
	-- 서브쿼리를 사용할때는 결합 대상 레코드 수를 사전에 압축해서 성능을 개선할 수 있음

		
				






