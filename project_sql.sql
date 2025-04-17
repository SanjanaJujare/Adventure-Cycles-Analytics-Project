create database Project_Group6;
use Project_Group6;

--

#1. Creating a union of SalesNew and SalesOld file. Table "Sales" was created after passing the below query:
create table sales as select * from salesnew union select * from salesold;

--

#2. Top 5 Customers. 
SELECT 
    c.CustomerFullName,
    round(SUM(s.SalesAmount), 2) AS TotalSpent
FROM 
    sales s
JOIN customers c ON s.CustomerKey = c.CustomerKey
GROUP BY c.CustomerFullName
ORDER BY TotalSpent DESC
LIMIT 5;

--

#3. Average Sales per Region

SELECT 
    r.SalesTerritoryRegion,
    round(AVG(s.SalesAmount), 2) AS AvgSales
FROM 
    sales s
JOIN region r ON s.SalesTerritoryKey = r.SalesTerritoryKey
GROUP BY r.SalesTerritoryRegion;

--

#4. Customers with no repeat purchases.

SELECT 
    c.CustomerFullName,
    COUNT(s.SalesOrderNumber) AS OrderCount
FROM 
    sales s
JOIN customers c ON s.CustomerKey = c.CustomerKey
GROUP BY c.CustomerFullName
HAVING COUNT(s.SalesOrderNumber) = 1;

--

#5. Customer Purchase Summary View.

CREATE VIEW CustomerPurchaseSummary AS
SELECT 
    c.CustomerFullName,
    c.EmailAddress,
    COUNT(s.SalesOrderNumber) AS TotalOrders,
    round(SUM(s.SalesAmount), 2) AS TotalSpent
FROM 
    sales s
JOIN customers c ON s.CustomerKey = c.CustomerKey
GROUP BY c.CustomerFullName, c.EmailAddress;

select * from customerpurchasesummary order by TotalSpent desc;

--

#6. Stored Procedure: Get Sales Summary by Region
call getsalesbyregion();

--

#7. Monthly Sales by year and Total of sales.

select Year, 
	round(sum(case when monthno = 1 then salesamount else 0 end), 2) as "January",
    round(sum(case when monthno = 2 then salesamount else 0 end), 2) as "February",
    round(sum(case when monthno = 3 then salesamount else 0 end), 2) as "March",
    round(sum(case when monthno = 4 then salesamount else 0 end), 2) as "April",
    round(sum(case when monthno = 5 then salesamount else 0 end), 2) as "May",
    round(sum(case when monthno = 6 then salesamount else 0 end), 2) as "June",
    round(sum(case when monthno = 7 then salesamount else 0 end), 2) as "July",
    round(sum(case when monthno = 8 then salesamount else 0 end), 2) as "August",
    round(sum(case when monthno = 9 then salesamount else 0 end), 2) as "September",
    round(sum(case when monthno = 10 then salesamount else 0 end), 2) as "October",
    round(sum(case when monthno = 11 then salesamount else 0 end), 2) as "November",
    round(sum(case when monthno = 12 then salesamount else 0 end), 2) as "December",
    round(sum(salesamount), 2) as "Total"
from sales group by year order by year;