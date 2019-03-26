--------------------------------------------------------------------------------------------------------------
-- T-SQL Fundamentals: Chap 02
--------------------------------------------------------------------------------------------------------------
SELECT
	c.custid, e.empid
FROM Sales.Customers c
	CROSS JOIN HR.Employees e;


SELECT
	e1.empid, e1.firstname, e1.lastname,
	e2.empid, e2.firstname, e2.lastname
FROM HR.Employees e1
	CROSS JOIN HR.Employees e2;

--------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS dbo.Digits;

CREATE TABLE dbo.Digits
(
	digit INT NOT NULL PRIMARY KEY
);

INSERT INTO dbo.Digits
	(digit)
VALUES
	(0),(1),(2),(3),(4),(5),(6),(7),(8),(9);

SELECT * FROM dbo.Digits;

SELECT
	(d3.digit * 100) + (d2.digit * 10) + (d1.digit + 1) n
FROM dbo.Digits d1
	CROSS JOIN dbo.Digits d2
	CROSS JOIN dbo.Digits d3
ORDER BY n;

--------------------------------------------------------------------------------------------------------------

