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
-- Exercises
--------------------------------------------------------------------------------------------------------------
-- 1.
SELECT TOP 10 * FROM dbo.Nums

SELECT 
	e.empid, e.firstname, e.lastname, n.n
FROM
	HR.Employees e
		CROSS JOIN dbo.Nums n
WHERE
	n.n <= 5


-- 2.
SELECT n.n, DATEADD(DAY, (n.n - 1), '20160612') dt
FROM dbo.Nums n
WHERE n.n <= 5;

SELECT
	e.empid, CAST(DATEADD(DAY, (n.n - 1), '20160612') AS DATE) dt
FROM
	HR.Employees e
		CROSS JOIN dbo.Nums n
WHERE
	n.n <= 5
ORDER BY
	e.empid, dt


-- 3.
