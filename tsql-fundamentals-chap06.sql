--------------------------------------------------------------------------------------------------------------
-- T-SQL Fundamentals: Chap 06
--------------------------------------------------------------------------------------------------------------

SELECT
	ROW_NUMBER() OVER (PARTITION BY country, region, city ORDER BY (SELECT 0)) AS rownum,
	country, region, city
FROM
	HR.Employees

INTERSECT

SELECT
	ROW_NUMBER() OVER (PARTITION BY country, region, city ORDER BY (SELECT 0)),
	country, region, city
FROM
	Sales.Customers;


--------------------------------------------------------------------------------------------------------------
-- Exercises Chap 05
--------------------------------------------------------------------------------------------------------------

-- 3.
SELECT TOP 10 * FROM Sales.Orders;

SELECT
	custid, empid
FROM Sales.Orders
WHERE orderdate BETWEEN '20160101' AND '20160131'

EXCEPT

SELECT
	custid, empid
FROM Sales.Orders
WHERE orderdate BETWEEN '20160201' AND '20160229'