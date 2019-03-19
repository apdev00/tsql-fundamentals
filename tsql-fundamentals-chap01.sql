--------------------------------------------------------------------------------------------------------------
-- T-SQL Fundamentals: Chap 01
--------------------------------------------------------------------------------------------------------------
SELECT *
FROM Sales.Orders
ORDER BY orderdate DESC
OFFSET 50 ROWS FETCH NEXT 25 ROWS ONLY;

SELECT
	orderid, custid, val,
	ROW_NUMBER() OVER (PARTITION BY custid ORDER BY val) AS rownum
FROM Sales.OrderValues
ORDER BY custid, val

SELECT * FROM sys.fn_helpcollations();

SELECT TOP 100 * FROM sys.table_types

SELECT COMPRESS(N'This is a test value, representing a much larger text file');
SELECT CAST(DECOMPRESS(COMPRESS(N'This is a test value, representing a much larger text file')) AS NVARCHAR(MAX));

SELECT CURRENT_TIMESTAMP

SELECT TRY_CAST('abc' AS INT)

--------------------------------------------------------------------------------------------------------------

SELECT * FROM sys.time_zone_info;

SELECT EOMONTH(GETDATE())

EXEC sys.sp_help @objname = N'Sales.Orders' -- nvarchar(776)

SELECT COLUMNPROPERTY(OBJECT_ID(N'Sales.Orders'))


--------------------------------------------------------------------------------------------------------------
-- Exercises
--------------------------------------------------------------------------------------------------------------
-- 1.
SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
WHERE orderdate >= '20150601' AND orderdate < '20150701'
ORDER BY orderdate, orderid;


-- 2.
SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
WHERE orderdate = EOMONTH(orderdate)
ORDER BY orderid;


-- 3.
SELECT empid, firstname, lastname
FROM HR.Employees
WHERE (LEN(firstname) - LEN(REPLACE(firstname, '2', ''))) + (LEN(lastname) - LEN(REPLACE(lastname, 'e', ''))) >= 2;


-- 4.
SELECT TOP 100 * FROM Sales.OrderDetails;

SELECT orderid, SUM((qty * unitprice)) 'totalvalue'
FROM Sales.OrderDetails
GROUP BY orderid
HAVING SUM((qty * unitprice)) >= 10000
ORDER BY totalvalue DESC


-- 5.
SELECT TOP 10 * FROM HR.Employees;

SELECT empid, lastname
FROM HR.Employees
WHERE lastname COLLATE Latin1_General_CS_AS LIKE N'[abcdefghijklmnopqrstuvwxyz]%'


-- 8.
SELECT TOP 10 * FROM Sales.Orders;

SELECT custid, orderdate, orderid, ROW_NUMBER() OVER (PARTITION BY custid ORDER BY orderdate, orderid) 'rownum'
FROM Sales.Orders