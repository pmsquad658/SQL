-- Having �� : group by �� ���� ��� ���տ� �Ǵٽ� ������ ������
--             �� WHERE ���� '���ڵ�'�� ������ �����Ѵٸ�, HAVING ���� '����'�� ������ �����ϴ� ���
-- SQL ����Ʈ ������ ACS �� : �������� DESC, �ش� �÷��� �������� �� 

SELECT name, phone_nbr, address, sex, age
  FROM Address
ORDER BY age DESC, phone_nbr ASC 
;

-- VIEW ����
CREATE VIEW CountAddress (v_address, cnt)
AS
SELECT address, COUNT(*)
  FROM Address
GROUP BY address
;
SELECT v_address, cnt
  FROM CountAddress;  

-- ���������� �� ���
SELECT v_address, cnt
  FROM ( SELECT address, COUNT(*)
                  FROM Address
               GROUP BY address ) AS CountAddress
;

-- IN ���� �������� ���
SELECT name
  FROM Address
WHERE name IN (SELECT name
                               FROM Address2)
;

-- CASE ��
SELECT name, address, 
	   CASE WHEN address = '�����' THEN '���'
	             WHEN address = '��õ��' THEN '���'
	             WHEN address = '�λ��' THEN '����'
	             WHEN address = '���ʽ�' THEN '����'
	             WHEN address = '��������' THEN 'ȣ��'            
                              ELSE NULL END AS district
  FROM Address;

-- UNION : �ߺ������� ������
-- �ߺ��� ����ϰ� �ʹٸ�, 'UNION ALL'
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

-- ������ �Լ�
-- ������ �Լ��� '���� ����� ���� GROUP BY ��' : �ڸ��� ��ɸ� ����
SELECT address, COUNT(*)
  FROM Address
GROUP BY address;

SELECT address,
              COUNT(*) OVER(PARTITION BY address)
  FROM Address;

-- �ڸ���� ����ǳ� �׷� �� ���� ���ڵ� �� ��ŭ �� ����� ��
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
                        VALUES ('�μ�', '080-3333-xxxx', '�����', '��', 30);

DELETE FROM Address
WHERE address = '��õ��';

UPDATE Address
    SET phone_nbr = '080-5849-XXXX',
           age = 20
WHERE name = '������';

-- UNION�� WHERE ������ ���� �б�� ���ϰ�
-- SELECT �������� CASE ���� ����Ѵ�
SELECT item_name, year, 
              CASE WHEN year <= 2001 THEN price_tax_ex
                        WHEN year >= 2022 THEN price_tax_in  END AS price
  FROM Items;

- CASE ���� ����� colunm/row ���̾ƿ� �̵� ����
SELECT prefecture,
              SUM(CASE WHEN sex = '1' THEN pop ELSE 0 END) AS pop_men,
              SUM(CASE WHEN sex = '2' THEN pop ELSE 0 END) AS pop_wom
  FROM Population
GROUP BY prefecture;

-- ���� ����� ���� �б�
SELECT emp_neme,
              CASE WHEN COUNT(*) = 1 THEN MAX(team)
                        WHEN COUNT(*) = 2 THEN '2���� �⹫'
                        WHEN COUNT(*) >= 3 THEN '3�� �̻��� �⹫'
                        END AS team
  FROM Employees 
GROUP BY emp_name;

-- UNION ���
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

-- IN �� ����� ���
SELECT key, name,
              date_1, flag_1,
              date_2, flag_2,
              date_3, flag_3
  FROM ThreeElements
WHERE ('2013-11-01','T') IN ((date_1, flg_1), (date_2, flg_2), (date_3, flg_3));

-- CASE ���� ����� ���
SELECT key, name,
              date_1, flag_1,
              date_2, flag_2,
              date_3, flag_3
  FROM ThreeElements
WHERE CASE WHEN date_1 = '2013-11-01' THEN flg_1
                        WHEN date_2 = '2013-11-01' THEN flg_2
                        WHEN date_3 = '2013-11-01' THEN flg_3
                        ELSE NULL END = 'T' ;

-- ## GROUP BY ���� �������� ��, SELECT ���� �Է��� �� �ִ� ���� 3���� ��
-- 1. ���
-- 2. GROUP BY ������ ����� ���� Ű
-- 3. ���� �Լ�
-- ������ ������� �ٸ� �ʵ带 ����ϱ�
SELECT id, 
              MAX(CASE WHEN data_type = 'A' THEN data_1 ELSE NULL END) AS data_1,
              MAX(CASE WHEN data_type = 'A' THEN data_1 ELSE NULL END) AS data_2,
              MAX(CASE WHEN data_type = 'B' THEN data_1 ELSE NULL END) AS data_3,
              MAX(CASE WHEN data_type = 'B' THEN data_1 ELSE NULL END) AS data_4,
              MAX(CASE WHEN data_type = 'B' THEN data_1 ELSE NULL END) AS data_5,
              MAX(CASE WHEN data_type = 'C' THEN data_1 ELSE NULL END) AS data_6
  FROM NonAggTble
GROUP BY id;

-- GROUP BY �� ��Ƽ�� �����ϱ� 
SELECT CASE WHEN age < 20 THEN '���'
                         WHEN age BETWEEN 20 AND 69 THEN '����'
                         WHEN age >= 70 THEN '����'
                         ELSE NULL END AS age_class,
                         COUNT(*)
  FROM persons
GROUP BY CASE WHEN age < 20 THEN '���'
                               WHEN age BETWEEN 20 AND 69 THEN '����'
                               WHEN age >= 70 THEN '����'
                               ELSE NULL END;


-- PARTITION BY ���� ����� �ڸ���, RANK()
-- partition �ȿ��� rank() ���� ���� ������
SELECT name, age,
              CASE WHEN age < 20 THEN '���'
                         WHEN age BETWEEN 20 AND 69 THEN '����'
                         WHEN age >= 70 THEN '����'
                         ELSE NULL END AS age_class,
                         RANK() OVER(PARTITION BY CASE WHEN age < 20 THEN '���'
                                                                                        WHEN age BETWEEN 20 AND 69 THEN '����'
                                                                                        WHEN age >= 70 THEN '����'
                                                                                        ELSE NULL END  ORDER BY age) AS age_rank_in_class
  FROM persons
ORDER BY age_class, age_rank_in_class;


-- ###################### �������� ���
-- �������� ��� �⺻
-- ���� �ּ� ���� ���� �����ϴ� �������� (R2) �� �����
-- ������ Receipts ���̺�� ������
-- MIN, MAX �� �����Լ���, �ٸ� ������ ������ ��
select R1.cust_id, R1.seq, R1.price
  from Receipts R1
         INNER JOIN (
           select cust_id, MIN(seq) AS min_seq
             from receipts
           group by cust_id ) R2
  ON R1.cust_id = R2.cust_id
AND R1.seq = R2.min_seq
;
-- RANK() 2 �� ���ؾ� �� ��
-- ������ �Լ� Ȱ�� ROW_NUMBER()
select cust_id, seq, price
  from (select cust_id, seq, price,
               ROW_NUMBER()
                 OVER (PARTITION BY cust_id ORDER BY seq) AS row_seq
        from Receipts ) WORK
where WORK.row_seq = 1
;

-- ���� ���ϰ� �׷캰 diff ���� ����ϴ� ����
-- �������� 4ȸ -> 1ȸ�� ���δ�

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

-- ���� ���� ��������
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


-- �������� Ȱ��_2
-- ���հ� ���� ����

-- 1. ������ ���� ����
select C.co_cd, C.district, sum_emp
  from Companies C
               INNER JOIN
                   ( select co_cd, SUM(emp_nbr) AS sum_emp
                       from Shops
                     where main_flg = 'Y'
                     group by co_cd ) CSUM
               on C.co_cd = CSUM.co_cd
;


-- 2. ������ ���� ����
select C.co_cd, MAX(C.district),  -- ** MAX() ����� group by ������ Ÿ���� ��� Ʈ��
          SUM(emp_nbr) AS sum_emp   
  from Companies C
              INNER JOIN
                  Shops S
              ON C.co_cd = S.co_cd
where main_flg = 'Y'
group by C.co_cd;

-- ���������� ������ ������ ������ �� �ִ� ���� ��������, ������ �ø��� ���� ��ȭ�� ����ų �� ����
-- SQL ������ �����ϴ� ������ I/O �� ������
-- ���������� ������ ������ �Լ��� ��ü�ϸ� ������ ������ ���ɼ��� ����
-- ���������� ����Ҷ��� ���� ��� ���ڵ� ���� ������ �����ؼ� ������ ������ �� ����

-- ##  23��. ���ڵ忡 ���� ���̱�
-- 1. �⺻ Ű�� �� ���� �ʵ��� ���
-- 1-1. ������ �Լ��� ���

select student_id, 
          ROW_NUMBER() OVER (ORDER BY student_id) AS seq
  from weights
;

-- 1-2. ��� ���������� ��� _ ��� ���� �����
-- ���� ���� ���
select student_id,
          ( select count(*)
              from weights W2
            where W2.student_id <= W1.student_id) AS seq
  from weights W1
;

-- 2. �⺻ Ű�� ���� ���� �ʵ�� �����Ǵ� ���
-- 2-1. ������ �Լ� ���
select class, student_id, 
          ROW_NUMBER() OVER (ORDER BY class, student_id) AS seq
  from weights2
;

-- 2-2. ��� ���������� ���
select class, student_id,
          ( select count(*)
              from weights2 W2
            where ( W2.class, W2.student_id) <= (W1.class, W1.student_id) AS seq
  from weights2 W1
;

-- 3. �׷츶�� ������ ���̴� ���
-- 3-1. ������ �Լ� ���
select class, student_id,
          ROW_NUMBER() OVER ( PARTITION BY class ORDER BY student_id) AS seq
  from weights2
;

-- 3-2. ��� ���������� ���
select class, student_id, 
          ( select count(*)
              from weights2 W2
            where W2.class = W1.class AND W2.student_id <= W1.student_id) AS seq
  from weights2 W1
;

-- 4. �߾Ӱ� ���ϱ�
-- 4-1. ���� ������ ���
select AVG(weight) AS median
  from ( select weight, 
                      ROW_NUMBER() OVER (ORDER BY weght ASC, student_id ASC) AS hi,
                      ROW_NUMBER() OVER (ORDER BY weght DESC, student_id DESC) AS lo
               from weights ) TMP
where hi IN (lo, lo +1, lo -1)
;

-- 4-2. ���� ������ ���
select AVG(weight)
  from ( select weight,
                      2*ROW_NUMBER() OVER(ORDER BY weight) - COUNT(*) OVER() AS diff
               from weights ) TMP
where diff BETWEEN 0 AND 2
;

-- #### �ڸ��� _ 6. 25

-- 1. group by �� case �� �ڸ���
select substr(name, 1, 1) AS label, 
            count(*)
  from Persons
group by substr(name, 1, 1);


select CASE when age < 20 then '���'
                       when age between 20 and 69 then '����'
                       when age >= 70 then '����'
                       else NULL END AS age_class,
            count(*)
  from Persons
group by CASE when age < 20 then '���'  -- �Ǵ� group by age_class
                       when age between 20 and 69 then '����'
                       when age >= 70 then '����'
                       else NULL END;

-- 1-1. 

select CASE when weight / POWER(height/100,2) < 18.5      then '��ü��'
                       when 18.5 <= weight / POWER(height/100,2) AND weight / POWER(height/100,2) < 25   then '����'
                       when 25 <= weight / POWER(height/100,2) then '��ü��'
                       else NULL end AS bmi,
             count(*)
  from Persons
group by CASE when weight / POWER(height/100,2) < 18.5      then '��ü��'
                       when 18.5 <= weight / POWER(height/100,2) AND weight / POWER(height/100,2) < 25   then '����'
                       when 25 <= weight / POWER(height/100,2) then '��ü��'
                       else NULL end;

-- 2. PARTITIN BY ���� ����� �ڸ���
-- GROUP BY ������ ���� ����� ������ ��
-- ���� ���̺� ������ �״�� �����ϸ�, �׷��� ���� �ű�� �÷��� �߰��� ��

select name, age, 
            CASE when age < 20 then '���'
                       when age BETWEEN 20 AND 69 then '����'
                       when age >= 70 '����'
                       ELSE NULL END AS age_class,
             RANK() OVER(PARTITION BY  CASE when age < 20 then '���'
                                                                                    when age BETWEEN 20 AND 69 then '����'
                                                                                    when age >= 70 '����'
                                                                                    ELSE NULL END 
                                          ORDER BY age) AS age_rank_in_class
  from Persons
ORDER BY age_class, age_rank_in_class ;

-- GROUP BY �� �Ǵ� ������ �Լ��� PARTIION BY ���� ������ �ڸ� �� ���
-- GROUP BY �� �Ǵ� ������ �Լ��� ���������� �ؽ� �Ǵ� ���� ó���� ����
-- �ؽ� �Ǵ� ������ �޸𸮸� ���� ����� ���� �޸𸮰� �����ϸ� �Ͻ� �������� ����Ҹ� ����� ���� ���� �߱�
-- GROUP BY  �� �Ǵ� ������ �Լ��� CASE ���� �Բ� ����ϸ� ������ �پ��� ���� ǥ���� �� ����



-- ################ ���� ###
-- 1. ���� ����

select E.emp_id, E.emp_name, E.dept_id, D.dept_name
  from Employees E
                 INNER JOIN
                     Departments D
                 on E.dept_id = D.dept_id;

-- 2. �ܺ� ����
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

-- 2. �ﰢ����
-- Table_A �� ���� ���̺�� Table_B �� �����ϰ� �� ����� Table_C �� ����

select A.col_a, B.col_b, C.col_c
  from Table_A A
                 INNER JOIN
                     Table_B B
                 on A.col_a = B.col_b

                     INNER JOIN
                         Table_C C
                     on A.col_a = C.col_c AND C.col_C = B.col_b;  -- Table_B �� Table_C �� ���� ������
                                                                                                        -- �������� ���� �� �߰��� �༭ B�� C ������ ȸ��

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







