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
-- 2.1
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


-- 3.1
SELECT TOP 10 * FROM Sales.Orders;

SELECT orderid, orderdate, custid, empid, 
	ROW_NUMBER() OVER (ORDER BY orderdate, orderid) rownum
FROM Sales.Orders;

WITH CTE_orders
AS
(
	SELECT orderid, orderdate, custid, empid, 
		ROW_NUMBER() OVER (ORDER BY orderdate, orderid) rownum
	FROM Sales.Orders
)

-- 3.2
SELECT * FROM CTE_orders WHERE rownum BETWEEN 11 AND 20;


-- 4
SELECT * FROM HR.Employees WHERE empid = 9;

WITH CTE_Emp AS
(
	SELECT empid, mgrid, firstname, lastname
	FROM HR.Employees
	WHERE empid = 9

	UNION ALL

	SELECT e.empid, e.mgrid, e.firstname, e.lastname
	FROM CTE_Emp
		INNER JOIN HR.Employees e
			ON CTE_Emp.mgrid = e.empid
)
SELECT * FROM CTE_Emp;


-- 5.1
SELECT TOP 10 * FROM Sales.Orders;
SELECT TOP 10 * FROM Sales.OrderDetails;

CREATE VIEW Sales.VEmpOrders
AS
	SELECT o.empid, YEAR(o.orderdate) orderyear, SUM(od.qty) qty
	FROM Sales.Orders o
		INNER JOIN Sales.OrderDetails od
			ON o.orderid = od.orderid
	GROUP BY o.empid, YEAR(o.orderdate)

SELECT * FROM Sales.VEmpOrders ORDER BY empid, orderyear;

SELECT v1.empid, v1.orderyear, v1.qty,
	(SELECT SUM(v2.qty)
	 FROM Sales.VEmpOrders v2
	 WHERE v2.empid = v1.empid
	   AND v2.orderyear <= v1.orderyear) runqty
FROM Sales.VEmpOrders v1
ORDER BY v1.empid, v1.orderyear;


-- 6.1
SELECT TOP 10 * FROM Production.Products;

CREATE FUNCTION Production.TopProducts
(
	@supid	INT
,	@n		INT
)
RETURNS TABLE
AS
	RETURN
		SELECT TOP (@n) productid, productname, unitprice
		FROM Production.Products
		WHERE supplierid = @supid
		ORDER BY unitprice DESC, productid DESC;

SELECT * FROM Production.TopProducts(5,2);

-- 6.2
SELECT s.supplierid, s.companyname, p.productid, p.productname, p.unitprice
FROM Production.Suppliers s
	CROSS APPLY Production.TopProducts(s.supplierid, 2) p;