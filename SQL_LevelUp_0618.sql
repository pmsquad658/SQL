-- Having 구 : group by 로 얻은 결과 집합에 또다시 조건을 지정함
--             즉 WHERE 구가 '레코드'에 조건을 지정한다면, HAVING 구는 '집합'에 조건을 지정하는 기능
-- SQL 디폴트 정렬은 ACS 임 : 내림차순 DESC, 해당 컬럼만 내일차순 됨 
SELECT name, phone_nbr, address, sex, age
  FROM Address
 ORDER BY age DESC, phone_nbr ASC ;

-- VIEW 생성
CREATE VIEW CountAddress (v_address, cnt)
AS
SELECT address, COUNT(*)
  FROM Address
 GROUP BY address;
SELECT v_address, cnt
  FROM CountAddress;  

-- 서브쿼리로 할 경우
SELECT v_address, cnt
  FROM ( SELECT address, COUNT(*)
           FROM Address
          GROUP BY address; ) AS CountAddress ;

-- IN 에서 서브쿼리 사용
SELECT name
  FROM Address
 WHERE name IN (SELECT name
                  FROM Address2) ;

-- CASE 식
SELECT name, address, 
	   CASE WHEN address = '서울시' THEN '경기'
	   CASE WHEN address = '인천시' THEN '경기'
	   CASE WHEN address = '부산시' THEN '영남'
	   CASE WHEN address = '속초시' THEN '관동'
	   CASE WHEN address = '서귀포시' THEN '호남'            
       ELSE NULL END AS district
 FROM Address;

-- UNION : 중복제거한 합집합
-- 중복을 허용하고 싶다면, 'UNION ALL'
SELECT *
  FROM Address
UNION
SELECT *
  FROM Address2;

-- INTERSECT, EXCEPT
SELECT *
  FROM Address
INTERSECT
SELECT *
  FROM Address2;
SELECT *
  FROM  Address
EXCEPT
SELECT *
  FROM Address2;

-- 윈도우 함수
-- 윈도우 함수는 '집약 기능이 없는 GROUP BY 구' : 자르기 기능만 있음
SELECT address, COUNT(*)
  FROM Address
 GROUP BY address;
SELECT address,
       COUNT(*) OVER(PARTITION BY address)
  FROM Address;

-- 자르기는 수행되나 그룹 내 값의 레코드 수 만큼 다 출력이 됨
SELECT address, 
	   COUNT(*) OVER(PARTITION BY address)
  FROM Address;
SELECT name,
       age,
       RANK() OVER(ORDER BY age DESC) AS rnk
  FROM Address;
SELECT name,
       age,
       DESE_RANK() OVER(ODER BY age DESC) AS dense_rank
-- INSERT, DELETE, UPDATE
INSERT INTO Address (name, phone_nbr, address, sex, age)
            VALUES ('인성', '080-3333-xxxx', '서울시', '남', 30);
DELETE FROM Address
  WHERE address = '인천시';
UPDATE Address
    SET phone_nbr = '080-5849-XXXX',
        age = 20
  WHERE name = '빛나래';

-- UNION과 WHERE 구에서 조건 분기는 피하고
-- SELECT 구문에서 CASE 식을 사용한다
SELECT item_name, year, 
       CASE WHEN year <= 2001 THEN price_tax_ex
            WHEN year >= 2022 THEN price_tax_in END AS price
  FROM Items ;

- CASE 식을 사용한 colunm/row 레이아웃 이동 문제
SELECT prefecture,
       SUM(CASE WHEN sex = '1' THEN pop ELSE 0 END) AS pop_men,
       SUM(CASE WHEN sex = '2' THEN pop ELSE 0 END) AS pop_wom
  FROM Population
 GROUP BY prefecture;

-- 집약 결과로 조건 분기
SELECT emp_neme,
       CASE WHEN COUNT(*) = 1 THEN MAX(team)
            WHEN COUNT(*) = 2 THEN '2개를 겸무'
            WHEN COUNT(*) >= 3 THEN '3개 이상을 겸무'
       END AS team
  FROM Employees 
 GROUP BY emp_name;

-- UNION 사용
SELECT col_1
  FROM Table_A
 WHERE col_2 = 'A'
UNION ALL
SELECT col_3
  FROM Table_B
 WHERE col_4 = 'B';
SELECT key, name,
       date_1, flag_1,
       date_2, flag_2,
       date_3, flag_3
  FROM ThreeElements
 WHERE date_1 = '2013-11-01'
   AND flg_1 = 'T'
UNION
SELECT key, name,
       date_1, flag_1,
       date_2, flag_2,
       date_3, flag_3
  FROM ThreeElements
 WHERE date_2 = '2013-11-01'
   AND flg_2 = 'T'
UNION
SELECT key, name,
       date_1, flag_1,
       date_2, flag_2,
       date_3, flag_3
  FROM ThreeElements
 WHERE date_3 = '2013-11-01'
   AND flg_3 = 'T';

-- IN 을 사용할 경우
SELECT key, name,
       date_1, flag_1,
       date_2, flag_2,
       date_3, flag_3
  FROM ThreeElements
 WHERE ('2013-11-01','T')
		   IN ((date_1, flg_1),
                date_2, flg_2),
                date_3, flg_3));

-- CASE 식을 사용할 경우
SELECT key, name,
       date_1, flag_1,
       date_2, flag_2,
       date_3, flag_3
  FROM ThreeElements
 WHERE CASE WHEN date_1 = '2013-11-01' THEN flg_1
       CASE WHEN date_2 = '2013-11-01' THEN flg_2
       CASE WHEN date_3 = '2013-11-01' THEN flg_3
       ELSE NULL END = 'T' ;

-- GROUP BY 구로 집약했을 때, SELECT 구에 입력할 수 있는 것은 3가지 뿐
-- 1. 상수
-- 2. GROUP BY 구에서 사용한 집약 키
-- 3. 집약 함수
-- 다음의 방법으로 다른 필드를 사용하기
SELECT id, 
       MAX(CASE WHEN data_type = 'A' THEN data_1 ELSE NULL END) AS data_1,
       MAX(CASE WHEN data_type = 'A' THEN data_1 ELSE NULL END) AS data_2,
       MAX(CASE WHEN data_type = 'B' THEN data_1 ELSE NULL END) AS data_3,
       MAX(CASE WHEN data_type = 'B' THEN data_1 ELSE NULL END) AS data_4,
       MAX(CASE WHEN data_type = 'B' THEN data_1 ELSE NULL END) AS data_5,
       MAX(CASE WHEN data_type = 'C' THEN data_1 ELSE NULL END) AS data_6
  FROM NonAggTble
 GROUP BY id;

-- GROUP BY 로 파티션 분할하기 
SELECT CASE WHEN age < 20 THEN '어린이'
            WHEN age BETWEEN 20 AND 69 THEN '성인'
            WHEN age >= 70 THEN '노인'
            ELSE NULL END AS age_class,
       COUNT(*)
  FROM persons
 GROUP BY CASE WHEN age < 20 THEN '어린이'
            WHEN age BETWEEN 20 AND 69 THEN '성인'
            WHEN age >= 70 THEN '노인'
            ELSE NULL END;


-- PARTITION BY 구를 사용한 자르기, RANK()
-- partition 안에서 rank() 구한 값을 구해줌
SELECT name,
       age,
       CASE WHEN age < 20 THEN '어린이'
            WHEN age BETWEEN 20 AND 69 THEN '성인'
            WHEN age >= 70 THEN '노인'
            ELSE NULL END AS age_class,
       RANK() OVER(PARTITION BY CASE WHEN age < 20 THEN '어린이'
                                     WHEN age BETWEEN 20 AND 69 THEN '성인'
                                     WHEN age >= 70 THEN '노인'
                                     ELSE NULL END
                   ORDER BY age) AS age_rank_in_class
  FROM persons
 ORDER BY age_class, age_rank_in_class;

