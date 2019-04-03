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