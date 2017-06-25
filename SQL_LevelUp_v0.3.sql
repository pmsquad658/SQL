-- Having 구 : group by 로 얻은 결과 집합에 또다시 조건을 지정함
--             즉 WHERE 구가 '레코드'에 조건을 지정한다면, HAVING 구는 '집합'에 조건을 지정하는 기능
-- SQL 디폴트 정렬은 ACS 임 : 내림차순 DESC, 해당 컬럼만 내일차순 됨 

SELECT name, phone_nbr, address, sex, age
  FROM Address
ORDER BY age DESC, phone_nbr ASC 
;

-- VIEW 생성
CREATE VIEW CountAddress (v_address, cnt)
AS
SELECT address, COUNT(*)
  FROM Address
GROUP BY address
;
SELECT v_address, cnt
  FROM CountAddress;  

-- 서브쿼리로 할 경우
SELECT v_address, cnt
  FROM ( SELECT address, COUNT(*)
                  FROM Address
               GROUP BY address ) AS CountAddress
;

-- IN 에서 서브쿼리 사용
SELECT name
  FROM Address
WHERE name IN (SELECT name
                               FROM Address2)
;

-- CASE 식
SELECT name, address, 
	   CASE WHEN address = '서울시' THEN '경기'
	             WHEN address = '인천시' THEN '경기'
	             WHEN address = '부산시' THEN '영남'
	             WHEN address = '속초시' THEN '관동'
	             WHEN address = '서귀포시' THEN '호남'            
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
  FROM Address
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

SELECT name, age,
              RANK() OVER(ORDER BY age DESC) AS rnk
  FROM Address;

SELECT name, age,
              DESE_RANK() OVER(ODER BY age DESC) AS dense_rank;


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
                        WHEN year >= 2022 THEN price_tax_in  END AS price
  FROM Items;

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
WHERE date_1 = '2013-11-01' AND flg_1 = 'T'
UNION
SELECT key, name,
              date_1, flag_1,
              date_2, flag_2,
              date_3, flag_3
  FROM ThreeElements
WHERE date_2 = '2013-11-01' AND flg_2 = 'T'
UNION
SELECT key, name,
              date_1, flag_1,
              date_2, flag_2,
              date_3, flag_3
  FROM ThreeElements
WHERE date_3 = '2013-11-01' AND flg_3 = 'T';

-- IN 을 사용할 경우
SELECT key, name,
              date_1, flag_1,
              date_2, flag_2,
              date_3, flag_3
  FROM ThreeElements
WHERE ('2013-11-01','T') IN ((date_1, flg_1), (date_2, flg_2), (date_3, flg_3));

-- CASE 식을 사용할 경우
SELECT key, name,
              date_1, flag_1,
              date_2, flag_2,
              date_3, flag_3
  FROM ThreeElements
WHERE CASE WHEN date_1 = '2013-11-01' THEN flg_1
                        WHEN date_2 = '2013-11-01' THEN flg_2
                        WHEN date_3 = '2013-11-01' THEN flg_3
                        ELSE NULL END = 'T' ;

-- ## GROUP BY 구로 집약했을 때, SELECT 구에 입력할 수 있는 것은 3가지 뿐
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
SELECT name, age,
              CASE WHEN age < 20 THEN '어린이'
                         WHEN age BETWEEN 20 AND 69 THEN '성인'
                         WHEN age >= 70 THEN '노인'
                         ELSE NULL END AS age_class,
                         RANK() OVER(PARTITION BY CASE WHEN age < 20 THEN '어린이'
                                                                                        WHEN age BETWEEN 20 AND 69 THEN '성인'
                                                                                        WHEN age >= 70 THEN '노인'
                                                                                        ELSE NULL END  ORDER BY age) AS age_rank_in_class
  FROM persons
ORDER BY age_class, age_rank_in_class;


-- ###################### 서브쿼리 사용
-- 서브쿼리 사용 기본
-- 고객의 최소 순번 값을 저장하는 서브쿼리 (R2) 를 만들고
-- 기존의 Receipts 테이블과 결합함
-- MIN, MAX 등 집계함수와, 다른 변수를 결합할 때
select R1.cust_id, R1.seq, R1.price
  from Receipts R1
         INNER JOIN (
           select cust_id, MIN(seq) AS min_seq
             from receipts
           group by cust_id ) R2
  ON R1.cust_id = R2.cust_id
AND R1.seq = R2.min_seq
;
-- RANK() 2 위 구해야 할 때
-- 윈도우 함수 활용 ROW_NUMBER()
select cust_id, seq, price
  from (select cust_id, seq, price,
               ROW_NUMBER()
                 OVER (PARTITION BY cust_id ORDER BY seq) AS row_seq
        from Receipts ) WORK
where WORK.row_seq = 1
;

-- 순위 구하고 그룹별 diff 값을 출력하는 예제
-- 서브쿼리 4회 -> 1회로 줄인다

SELECT cust_id, 
               SUM(CASE WHEN min_seq = 1 THEN price ELSE 0 END)
            - SUM(CASE WHEN max_seq = 1 THEN price ELSE 0 END) AS diff
  from ( select cust_id, price,
                       ROW_NUMBER() OVER (PARTITION BY cust_id ORDER BY seq) AS min_seq,
                       ROW_NUMBER() OVER (PARTITION BY cust_id ORDER BY seq DESC) AS max_seq
               from Receipts) WORK
where WORK.min_seq = 1
           OR WORK.max_seq = 1
GROUP BY cust_id
;

-- 위와 같은 서브쿼리
select tmp_min.cust_id,
          tmp_min.price - tmp_max.price as diff
  from ( select R1.cust_id, R1.seq, R1.price
               from Receipts R1
                         INNER JOIN
                                ( select cust_id, min(seq) AS min seq
                                     from Receipts
                                  group by cust_id) R2
                         on R1.cust_id = R2.cust_id AND R1.seq = R2.min_seq) TMP_MIN
      INNER JOIN
           ( select R3.cust_id, R3.seq, R3.price
               from Receipts R3
                        INNER JOIN
                            ( select cust_id, MAX(seq) AS max_seq
                                from Receipts
                              group by cust_id) R4
                       on R3.cust_id = R4.cust_id AND R3.seq = R4.max_seq ) TMP_MAX
     on TMP_MIN.cust_id = TMP_MAX.cust_id
;


-- 서브쿼리 활용_2
-- 결합과 집약 순서

-- 1. 집약을 먼저 수행
select C.co_cd, C.district, sum_emp
  from Companies C
               INNER JOIN
                   ( select co_cd, SUM(emp_nbr) AS sum_emp
                       from Shops
                     where main_flg = 'Y'
                     group by co_cd ) CSUM
               on C.co_cd = CSUM.co_cd
;


-- 2. 결합을 먼저 수행
select C.co_cd, MAX(C.district),  -- ** MAX() 사용은 group by 절에서 타변수 사용 트릭
          SUM(emp_nbr) AS sum_emp   
  from Companies C
              INNER JOIN
                  Shops S
              ON C.co_cd = S.co_cd
where main_flg = 'Y'
group by C.co_cd;

-- 서브쿼리는 복잡한 문제를 분할할 수 있는 편리한 도구지만, 결합을 늘리는 성능 악화를 일으킬 수 있음
-- SQL 성능을 결정하는 요인은 I/O 가 절대적
-- 서브쿼리와 결합을 윈도우 함수로 대체하면 성능을 개선할 가능성이 있음
-- 서브쿼리를 사용할때는 결합 대상 레코드 수를 사전에 압축해서 성능을 개선할 수 있음

-- ##  23강. 레코드에 순번 붙이기
-- 1. 기본 키가 한 개의 필드일 경우
-- 1-1. 윈도우 함수를 사용

select student_id, 
          ROW_NUMBER() OVER (ORDER BY student_id) AS seq
  from weights
;

-- 1-2. 상관 서브쿼리를 사용 _ 재귀 집합 만들기
-- 위와 같은 결과
select student_id,
          ( select count(*)
              from weights W2
            where W2.student_id <= W1.student_id) AS seq
  from weights W1
;

-- 2. 기본 키가 여러 개의 필드로 구성되는 경우
-- 2-1. 윈도우 함수 사용
select class, student_id, 
          ROW_NUMBER() OVER (ORDER BY class, student_id) AS seq
  from weights2
;

-- 2-2. 상관 서브쿼리를 사용
select class, student_id,
          ( select count(*)
              from weights2 W2
            where ( W2.class, W2.student_id) <= (W1.class, W1.student_id) AS seq
  from weights2 W1
;

-- 3. 그룹마다 순번을 붙이는 경우
-- 3-1. 윈도우 함수 사용
select class, student_id,
          ROW_NUMBER() OVER ( PARTITION BY class ORDER BY student_id) AS seq
  from weights2
;

-- 3-2. 상관 서브쿼리를 사용
select class, student_id, 
          ( select count(*)
              from weights2 W2
            where W2.class = W1.class AND W2.student_id <= W1.student_id) AS seq
  from weights2 W1
;

-- 4. 중앙값 구하기
-- 4-1. 절차 지향적 방법
select AVG(weight) AS median
  from ( select weight, 
                      ROW_NUMBER() OVER (ORDER BY weght ASC, student_id ASC) AS hi,
                      ROW_NUMBER() OVER (ORDER BY weght DESC, student_id DESC) AS lo
               from weights ) TMP
where hi IN (lo, lo +1, lo -1)
;

-- 4-2. 절차 지향적 방법
select AVG(weight)
  from ( select weight,
                      2*ROW_NUMBER() OVER(ORDER BY weight) - COUNT(*) OVER() AS diff
               from weights ) TMP
where diff BETWEEN 0 AND 2
;

-- #### 자르기 _ 6. 25

-- 1. group by 와 case 로 자르기
select substr(name, 1, 1) AS label, 
            count(*)
  from Persons
group by substr(name, 1, 1);


select CASE when age < 20 then '어린이'
                       when age between 20 and 69 then '성인'
                       when age >= 70 then '노인'
                       else NULL END AS age_class,
            count(*)
  from Persons
group by CASE when age < 20 then '어린이'  -- 또는 group by age_class
                       when age between 20 and 69 then '성인'
                       when age >= 70 then '노인'
                       else NULL END;

-- 1-1. 

select CASE when weight / POWER(height/100,2) < 18.5      then '저체중'
                       when 18.5 <= weight / POWER(height/100,2) AND weight / POWER(height/100,2) < 25   then '정상'
                       when 25 <= weight / POWER(height/100,2) then '과체중'
                       else NULL end AS bmi,
             count(*)
  from Persons
group by CASE when weight / POWER(height/100,2) < 18.5      then '저체중'
                       when 18.5 <= weight / POWER(height/100,2) AND weight / POWER(height/100,2) < 25   then '정상'
                       when 25 <= weight / POWER(height/100,2) then '과체중'
                       else NULL end;

-- 2. PARTITIN BY 구를 사용한 자르기
-- GROUP BY 구에서 집약 기능을 제외한 것
-- 원본 테이블 정보를 그대로 유지하며, 그룹의 순위 매기기 컬럼을 추가할 때

select name, age, 
            CASE when age < 20 then '어린이'
                       when age BETWEEN 20 AND 69 then '성인'
                       when age >= 70 '노인'
                       ELSE NULL END AS age_class,
             RANK() OVER(PARTITION BY  CASE when age < 20 then '어린이'
                                                                                    when age BETWEEN 20 AND 69 then '성인'
                                                                                    when age >= 70 '노인'
                                                                                    ELSE NULL END 
                                          ORDER BY age) AS age_rank_in_class
  from Persons
ORDER BY age_class, age_rank_in_class ;

-- GROUP BY 구 또는 윈도우 함수의 PARTIION BY 구는 집합을 자를 때 사용
-- GROUP BY 구 또는 윈도우 함수는 내부적으로 해시 또는 정렬 처리를 실행
-- 해시 또는 정렬은 메모리를 많이 사용해 만약 메모리가 부족하면 일시 영역으로 저장소를 사용해 성능 문제 야기
-- GROUP BY  구 또는 윈도우 함수와 CASE 식을 함께 사용하면 굉장히 다양한 것을 표현할 수 있음



-- ################ 결합 ###
-- 1. 내부 결합

select E.emp_id, E.emp_name, E.dept_id, D.dept_name
  from Employees E
                 INNER JOIN
                     Departments D
                 on E.dept_id = D.dept_id;

-- 2. 외부 결합
select E.imp_id, E.emp_name, E.dept_name
  from Departments D
                 LEFT OUTER JOIN
                     Employees E
                 on D.dept_id = E.dept_id ;

select E.imp_id, E.emp_name, E.dept_name
  from Departments E
                 RIGHT OUTER JOIN
                     Employees D
                 on E.dept_id = D.dept_id ;

-- 2. 삼각결합
-- Table_A 를 구동 테이블로 Table_B 와 결합하고 그 결과를 Table_C 와 결합

select A.col_a, B.col_b, C.col_c
  from Table_A A
                 INNER JOIN
                     Table_B B
                 on A.col_a = B.col_b

                     INNER JOIN
                         Table_C C
                     on A.col_a = C.col_c AND C.col_C = B.col_b;  -- Table_B 와 Table_C 의 결합 조건이
                                                                                                        -- 존재하지 않을 때 추가해 줘서 B와 C 결합을 회피

-- 3. EXISTS / NOT EXISTS

select dept_id, dept_name
  from Deprtments D
where exists ( select *
                               from Employees E
                             where E.dept_id = D.dept_id);


select dept_id, dept_name
  from Departments D
where NOT EXISTS ( select *
                                           from Employees E
                                         where E.dept_id = D.dept_id);







