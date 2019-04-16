--------------------------------------------------------------------------------------------------------------
-- T-SQL Fundamentals: Chap 04
--------------------------------------------------------------------------------------------------------------
SELECT
	o1.custid, o1.orderid, o1.orderdate, o1.empid
FROM
	Sales.Orders o1
WHERE
	o1.orderid = 
	(SELECT MAX(o2.orderid)
	 FROM Sales.Orders o2
	 WHERE o2.custid = o1.custid)
ORDER BY
	o1.custid;

-------------------------------

SELECT
	o1.orderid
,	o1.custid
,	o1.val
,	[pct] = CAST(100.00 * o1.val / (SELECT SUM(o2.val)
									FROM Sales.OrderValues o2
									WHERE o2.custid = o1.custid) AS NUMERIC(5,2))
FROM
	Sales.OrderValues o1
ORDER BY
	o1.custid, o1.orderid;

--------------------------------

SELECT
	o1.orderid
,	o1.orderdate
,	o1.empid
,	o1.custid
,	[prevorderid] =	(SELECT MAX(o2.orderid)
					 FROM Sales.Orders o2
					 WHERE o2.orderid < o1.orderid)
FROM
	Sales.Orders o1;

--------------------------------

SELECT * FROM Sales.OrderTotalsByYear;

SELECT
	o1.orderyear, o1.qty,  (SELECT SUM(o2.qty)
							FROM Sales.OrderTotalsByYear o2
							WHERE o2.orderyear <= o1.orderyear) AS runqty
FROM
	Sales.OrderTotalsByYear o1
ORDER BY
	o1.orderyear;

--------------------------------

DROP TABLE IF EXISTS Sales.MyShippers;

CREATE TABLE Sales.MyShippers
(
	shipper_id	INT	NOT NULL,
	companyname NVARCHAR(40) NOT NULL,
	phone		NVARCHAR(24) NOT NULL,
	CONSTRAINT PK_MyShippers PRIMARY KEY(shipper_id)
);

INSERT INTO Sales.MyShippers
(
    shipper_id,
    companyname,
    phone
)
VALUES
(1, N'Shipper GVSUA', N'(503) 555-0137'),
(2, N'Shipper ETYNR', N'(425) 555-0136'),
(3, N'Shipper ZHISN', N'(415) 555-0138');

SELECT * FROM Sales.MyShippers;
SELECT * FROM Sales.Orders WHERE custid = 43

SELECT *
FROM Sales.MyShippers
WHERE shipper_id IN (SELECT s.shipper_id FROM Sales.Orders s WHERE s.custid = 43);

--------------------------------------------------------------------------------------------------------------
-- Exercises: Chap 04
--------------------------------------------------------------------------------------------------------------
-- 1.
SELECT * FROM Sales.Orders;

SELECT o1.orderid, o1.orderdate, o1.custid, o1.empid
FROM Sales.Orders o1
WHERE o1.orderdate = (SELECT MAX(orderdate) FROM Sales.Orders)

-- 2.
SELECT custid, orderid, orderdate, empid
FROM Sales.Orders
WHERE custid IN (
	SELECT TOP 1 WITH TIES custid
	FROM Sales.Orders
	GROUP BY custid
	ORDER BY COUNT(*) DESC)

-- 3.
SELECT TOP 10 * FROM Sales.Orders;
SELECT TOP 10 * FROM HR.Employees;

SELECT empid, firstname,lastname
FROM HR.Employees
WHERE empid NOT IN (
	SELECT empid
	FROM Sales.Orders
	WHERE orderdate >= '20160501')

-- 4.
SELECT TOP 10 * FROM Sales.Customers;
SELECT TOP 10 * FROM HR.Employees;

SELECT DISTINCT country
FROM Sales.Customers
WHERE country NOT IN (
	SELECT country
	FROM HR.Employees
	WHERE country IS NOT NULL)

-- 5.
SELECT TOP 10 * FROM Sales.Orders;

SELECT o1.custid, o1.orderid, o1.orderdate, o1.empid
FROM Sales.Orders o1
WHERE o1.orderdate = (
	SELECT MAX(o2.orderdate)
	FROM Sales.Orders o2
	WHERE o2.custid = o1.custid)
ORDER BY o1.custid;

-- 6.
SELECT custid, companyname
FROM Sales.Customers
WHERE custid IN (
	SELECT custid
	FROM Sales.Orders
	WHERE YEAR(orderdate) = 2015)
  AND custid NOT IN (
		SELECT custid
	FROM Sales.Orders
	WHERE YEAR(orderdate) = 2016);

-- 7.
SELECT TOP 10 * FROM Sales.OrderDetails;

SELECT DISTINCT c.custid, c.companyname
FROM Sales.Customers c
	INNER JOIN Sales.Orders o
		ON c.custid = o.custid
	INNER JOIN Sales.OrderDetails od
		ON o.orderid = od.orderid
WHERE od.productid = 12;

-- 8.
SELECT TOP 10 * FROM Sales.CustOrders;

SELECT o1.custid, o1.ordermonth, o1.qty,
	(SELECT SUM(o2.qty)
	 FROM Sales.CustOrders o2
	 WHERE o2.ordermonth <= o1.ordermonth
	   AND o2.custid = o1.custid) 'runqty'
FROM Sales.CustOrders o1
ORDER BY o1.custid, o1.ordermonth

-- 10.
SELECT TOP 10 * FROM Sales.Orders;

SELECT o1.custid, o1.orderdate, o1.orderid, 
	(SELECT MAX(o2.orderdate)
	 FROM Sales.Orders o2
	 WHERE o2.custid = o1.custid
	   AND o2.orderdate <= o1.orderdate
	   AND o2.orderid < o1.orderid)
FROM Sales.Orders o1