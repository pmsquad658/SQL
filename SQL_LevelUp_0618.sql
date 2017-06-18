-- Having �� : group by �� ���� ��� ���տ� �Ǵٽ� ������ ������
--             �� WHERE ���� '���ڵ�'�� ������ �����Ѵٸ�, HAVING ���� '����'�� ������ �����ϴ� ���
-- SQL ����Ʈ ������ ACS �� : �������� DESC, �ش� �÷��� �������� �� 
SELECT name, phone_nbr, address, sex, age
  FROM Address
 ORDER BY age DESC, phone_nbr ASC ;

-- VIEW ����
CREATE VIEW CountAddress (v_address, cnt)
AS
SELECT address, COUNT(*)
  FROM Address
 GROUP BY address;
SELECT v_address, cnt
  FROM CountAddress;  

-- ���������� �� ���
SELECT v_address, cnt
  FROM ( SELECT address, COUNT(*)
           FROM Address
          GROUP BY address; ) AS CountAddress ;

-- IN ���� �������� ���
SELECT name
  FROM Address
 WHERE name IN (SELECT name
                  FROM Address2) ;

-- CASE ��
SELECT name, address, 
	   CASE WHEN address = '�����' THEN '���'
	   CASE WHEN address = '��õ��' THEN '���'
	   CASE WHEN address = '�λ��' THEN '����'
	   CASE WHEN address = '���ʽ�' THEN '����'
	   CASE WHEN address = '��������' THEN 'ȣ��'            
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
  FROM  Address
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
SELECT name,
       age,
       RANK() OVER(ORDER BY age DESC) AS rnk
  FROM Address;
SELECT name,
       age,
       DESE_RANK() OVER(ODER BY age DESC) AS dense_rank
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
            WHEN year >= 2022 THEN price_tax_in END AS price
  FROM Items ;

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

-- IN �� ����� ���
SELECT key, name,
       date_1, flag_1,
       date_2, flag_2,
       date_3, flag_3
  FROM ThreeElements
 WHERE ('2013-11-01','T')
		   IN ((date_1, flg_1),
                date_2, flg_2),
                date_3, flg_3));

-- CASE ���� ����� ���
SELECT key, name,
       date_1, flag_1,
       date_2, flag_2,
       date_3, flag_3
  FROM ThreeElements
 WHERE CASE WHEN date_1 = '2013-11-01' THEN flg_1
       CASE WHEN date_2 = '2013-11-01' THEN flg_2
       CASE WHEN date_3 = '2013-11-01' THEN flg_3
       ELSE NULL END = 'T' ;

-- GROUP BY ���� �������� ��, SELECT ���� �Է��� �� �ִ� ���� 3���� ��
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
SELECT name,
       age,
       CASE WHEN age < 20 THEN '���'
            WHEN age BETWEEN 20 AND 69 THEN '����'
            WHEN age >= 70 THEN '����'
            ELSE NULL END AS age_class,
       RANK() OVER(PARTITION BY CASE WHEN age < 20 THEN '���'
                                     WHEN age BETWEEN 20 AND 69 THEN '����'
                                     WHEN age >= 70 THEN '����'
                                     ELSE NULL END
                   ORDER BY age) AS age_rank_in_class
  FROM persons
 ORDER BY age_class, age_rank_in_class;

