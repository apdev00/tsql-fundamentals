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