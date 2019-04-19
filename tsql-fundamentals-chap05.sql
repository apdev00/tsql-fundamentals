--------------------------------------------------------------------------------------------------------------
-- T-SQL Fundamentals: Chap 05
--------------------------------------------------------------------------------------------------------------
WITH C AS
(
	SELECT YEAR(orderdate) orderyear, custid
	FROM Sales.Orders
)
SELECT * FROM C;


WITH EmpsCTE AS
(
	SELECT empid, mgrid, firstname, lastname
	FROM HR.Employees
	WHERE empid = 1

	UNION ALL

	SELECT c.empid, c.mgrid, c.firstname, c.lastname
	FROM EmpsCTE p
		INNER JOIN HR.Employees c
			ON c.mgrid = p.empid
)
SELECT *
FROM EmpsCTE;

--------------------------------------------------------------------------------------------------------------
GO

ALTER VIEW Sales.USACusts
WITH ENCRYPTION
AS
SELECT
	custid
,	companyname
,	contactname
,	contacttitle
,	address
,	city
,	region
,	postalcode
,	country
,	phone
,	fax
FROM
	Sales.Customers
WHERE
	country = N'USA';
GO

SELECT OBJECT_DEFINITION(OBJECT_ID('Sales.USACusts'));
EXEC sp_helptext 'Sales.USACusts';

--------------------------------------------------------------------------------------------------------------
-- APPLY operators -- see page 181 in book

SELECT TOP 10 * FROM Sales.Customers;
SELECT TOP 10 * FROM Sales.Orders;

SELECT c.custid, a.orderid, a.orderdate
FROM Sales.Customers c
	CROSS APPLY
		(SELECT TOP (3) o.orderid, o.empid, o.orderdate, o.requireddate
		 FROM Sales.Orders o
		 WHERE o.custid = c.custid
		 ORDER BY o.orderdate DESC, o.orderid DESC) AS a;


SELECT c.custid, a.orderid, a.orderdate
FROM Sales.Customers c
	OUTER APPLY
		(SELECT o.orderid, o.empid, o.orderdate, o.requireddate
		 FROM Sales.Orders o
		 WHERE o.custid = c.custid
		 ORDER BY o.orderdate DESC, o.orderid DESC
		 OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY) AS a;


GO

CREATE FUNCTION dbo.TopOrders
(
	@custid INT
,	@n INT
)
RETURNS TABLE
AS
	RETURN
		SELECT TOP (@n) orderid, empid, orderdate, requireddate
		FROM Sales.Orders
		WHERE custid = @custid
		ORDER BY orderdate DESC, orderid DESC;
GO

SELECT
	c.custid, c.companyname, a.orderid, a.empid, a.orderdate, a.requireddate
FROM Sales.Customers c
	OUTER APPLY dbo.TopOrders(c.custid, 3) a

--------------------------------------------------------------------------------------------------------------
-- Exercises Chap 05
--------------------------------------------------------------------------------------------------------------
--2.1
SELECT TOP 10 * FROM Sales.Orders;

SELECT empid, MAX(orderdate) maxorderdate
FROM Sales.Orders
GROUP BY empid;

-- 2.2
SELECT o.empid, o.orderdate, o.orderid, o.custid
FROM Sales.Orders o
	INNER JOIN (SELECT empid, MAX(orderdate) maxorderdate
				FROM Sales.Orders
				GROUP BY empid) a
		ON o.orderdate = a.maxorderdate
		AND o.empid = a.empid
ORDER BY o.empid DESC, o.orderid DESC;

-- test change #2 into branch