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