/*=============================================
Author:      Tyrell Clark
Create date: October 2023
Last Modified: October 2023
Description: In this project I will do some exploration on the sample 'AdventureWorks2019' SQL Server Database

About AdventureWorks:
        Microsoft product sample for an online transaction processing database. 
        It supports a fictitious, multinational manufacturing company that sells bicycles and cycling accessories.       
=============================================*/
----------------------------List the top 5 products in terms of sales revenue.
SELECT 
  TOP 5 SOD.ProductID, 
  P.Name, 
  SUM(SOH.SUBTOTAL) AS TOTAL_REVENUE 
FROM 
  SALES.SalesOrderDetail SOD 
  JOIN SALES.SALESORDERHEADER SOH ON SOD.SalesOrderID = SOH.SalesOrderID 
  JOIN PRODUCTION.Product P ON SOD.ProductID = P.ProductID 
GROUP BY 
  SOD.ProductID, 
  P.Name 
ORDER BY 
  count(SOH.SubTotal) DESC;
----------------------------Retrieve the total number of customers in each geographic region.
SELECT 
  ST.CountryRegionCode, 
  ST.Name, 
  COUNT(DISTINCT CUSTOMERID) AS COUNT_OF_CUSTOMERS 
FROM 
  SALES.SalesTerritory ST 
  JOIN SALES.CUSTOMER C ON ST.TERRITORYID = C.TERRITORYID 
GROUP BY 
  ST.CountryRegionCode, 
  ST.Name;
----------------------------Retrieve a list of products along with their respective categories.
SELECT 
  P.PRODUCTID, 
  P.NAME, 
  PC.Name AS CATEGORY 
FROM 
  PRODUCTION.PRODUCT P 
  JOIN PRODUCTION.PRODUCTSUBCATEGORY PSC ON P.PRODUCTSUBCATEGORYID = PSC.PRODUCTSUBCATEGORYID 
  JOIN PRODUCTION.PRODUCTCATEGORY PC ON PSC.PRODUCTCATEGORYID = PC.PRODUCTCATEGORYID;
----------------------------Find the total sales amount for each year.
SELECT 
  DATEPART(YEAR, SOH.ORDERDATE) AS YEAR, 
  SUM(SOH.SUBTOTAL) AS TOTAL_SALES 
FROM 
  SALES.SalesOrderHeader SOH 
GROUP BY 
  DATEPART(YEAR, SOH.ORDERDATE) 
ORDER BY 
  DATEPART(YEAR, SOH.ORDERDATE) DESC;
----------------------------Determine the maximum and minimum sales amount for each product category.
SELECT 
  PC.NAME AS Category, 
  MAX(SOD.UNITPRICE) AS MAX_SALES, 
  MIN(SOD.UNITPRICE) AS MIN_SALES 
FROM 
  PRODUCTION.PRODUCT P 
  JOIN PRODUCTION.PRODUCTSUBCATEGORY PSC ON P.PRODUCTSUBCATEGORYID = PSC.PRODUCTSUBCATEGORYID 
  JOIN PRODUCTION.PRODUCTCATEGORY PC ON PSC.PRODUCTCATEGORYID = PC.PRODUCTCATEGORYID 
  JOIN SALES.SalesOrderDetail SOD ON SOD.PRODUCTID = p.ProductID 
GROUP BY 
  PC.NAME;
----------------------------List all customers who have placed orders worth more than the average order value.
WITH MY_CTE AS (
  SELECT 
    AVG(SUBTOTAL) AS AVG_SUBTOTAL 
  FROM 
    SALES.SalesOrderHeader
) 
SELECT 
  C.CUSTOMERID, 
  SOH.SUBTOTAL 
FROM 
  SALES.Customer C 
  JOIN SALES.SalesOrderHeader SOH ON C.CUSTOMERID = SOH.CustomerID CROSS 
  JOIN MY_CTE MC 
WHERE 
  SOH.SUBTOTAL > MC.AVG_SUBTOTAL;
----------------------------Display the top 10 most frequent customers based on their order count.
SELECT 
  TOP 10 c.CustomerID, 
  COUNT(o.CustomerID) AS OrderCount 
FROM 
  Sales.Customer c 
  INNER JOIN Sales.SalesOrderHeader o ON c.CustomerID = o.CustomerID 
GROUP BY 
  c.CustomerID 
ORDER BY 
  OrderCount DESC
