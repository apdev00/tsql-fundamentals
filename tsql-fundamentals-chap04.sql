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