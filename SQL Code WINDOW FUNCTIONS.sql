--Windows Functions they are allowed to you the calculation like aggrigations on a specific subset data,without losing the level of details of rows
-- the diffrence between GROUP BY and Window function is:
--GROUP BY :reterns a single rows for the same grop wheathe the windows function return the results for each row


--TASK1 : find the total sales across all orders
select 
	sum(Sales) TotalSales
from sales.Orders

--TASK2 : find the total sales for each product
select 
	ProductID,
	sum(Sales) TotalSales
from sales.Orders
group by ProductID

--TASK3 : find the total sales for each product, additionally provide details such order_id & order date
--  call the window function by using OVER() after aggrigation function.
select 
	ProductID,
	OrderID,
	OrderDate,
	sum(Sales) over(partition by ProductID) as TotalSalesByProducts
from sales.Orders

-- Task4: find the total sales for all product, additionally provide details such order_id & order date
select 
	ProductID,
	OrderID,
	OrderDate,
	sum(Sales) over() TotalSales
from sales.Orders

--Task5: find the total sales for all products , 
--find the total sales for each product,
-- find the total sales for each combination of product and order status,
--additionally provide details such order_id & order date.
select 
	ProductID,
	OrderStatus,
	OrderID,
	OrderDate,
	sales,
	sum(Sales) over() TotalSales,
	sum(Sales) over(partition by ProductID) as TotalSalesByProducts,
	sum(sales) over(partition by ProductID , OrderStatus) TotalSalesByProductsAndStatus
from sales.Orders

-- Task 5 : Rank each order based on their sales from highest to lowest,
--additionally provide details such order_id & order date.

select 
	OrderID,
	OrderDate,
	sales,
	Rank() over(order by sales desc ) as RankSales
from sales.orders

-- Frame Clause 

Select
	OrderID,
	OrderDate,
	sales,
	OrderStatus,
	Sum(sales) over(Partition by OrderStatus order by OrderDate
	Rows between Current row and 2 following) TotalSales
from sales.Order

-- Task 6: find the total sales for each order status , only for two products 101 and 102

Select 
ProductID,
Sales,
OrderID,
OrderStatus,
sum(sales) Over(Partition by OrderStatus ) TotalSales
from sales.Orders
where ProductID in (101,102)

-- Task 4 :Rank the customer based on their sales
-- In order to solve this task we have to use Goup BY and Window Function because there are 2 aggifation function we have to use RANK() and SUM() so basiclly we can use SUM() with GROUP BY and using RANK() with Window function.

select
	CustomerID,
	sum(sales) as TotalSales,
	Rank() over( order by sum(sales) desc) CustomerRank
from Sales.Orders 
group by CustomerID

--HINT: SQL its allowed to use Group By with Winsow Function under one condition that anything that use inside the Window Function should be part of Group By .
-- in our task we fullfild the task cause we used SUM(Sales) in Window function and SUM(Sales) is part of Group by,
-- So if we changed and put instead the SUM(Sales) like Sales it wont work cause it is not part of Group BY .


--Aggregation Window Functions

-- There are many aggrigation functions and the most using functions are:

--COUNT() FUNCTION
--SUM() FUNCTION
--AVG() FUNCTION
--MIN() FUNCTION
--MAX() FUNCTION
--COUNT FUNCTION



--TASK1: find the total numbar of orders,
-- provide detials such orderId and orderDate.

select 
	OrderID,
	OrderDate,
	count(*)  over() TotalOrders 
from Sales.Orders

--TASK2 : find the total numbar of orders,
--Find the total number of each customers,
-- provide detials such orderId and orderDate.
select 
	CustomerID,
	OrderID,
	OrderDate,
	count(*)  over() TotalOrders,
	count(*) over(partition by CustomerID) OrdersByCustomer
from Sales.Orders

--TASK3 : Find the total number of  customers,
-- provide all customer detials.
select 
	*,
	count(*) over() CustomersNumber
from Sales.Customers

--TASK 5 : find the total number of Scors and countries for the customers.
-- HINT : we can use the count(column name)  weather to check  do we have NULL values in that column or not , also to check the duplicate values

select 
	*,
	count(*) over() TotalCustomer,
	count(Score) over() TotalScores,
	count(Country) over() TotalCountry
from Sales.Customers

-- TASK 6 : check weather the table 'Orders' contains any duplicate rows.
-- HINT : to check weather we have a duplicate data or not we have to check the Primery Key(PK) column and in this task the PK is OrderID
select 
	OrderID,
	count(*) over(partition by OrderID) CkeckPK
from Sales.Orders

-- Here another example to find the duplicate data
select
* 
from(
	Select
		OrderID,
		count(*) over(partition by OrderID) CkeckPK
	from Sales.OrdersArchive
)as t
 where CkeckPK > 1
 
--HINT: we used subquires because we can not use window Function in Where cluase 


--TASK 7 : Find the total sales across all orders and the total sales for each product,
-- Additionally,provide details such as order ID and order Date.

select 
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	sum(sales)over() TotalSales ,
	sum(sales) over(partition by ProductID) SalesByProduct 
from Sales.Orders


--TASK 8 : find the percentage contribution of each product's sales to the total sales

select 
	OrderID,
	ProductID,
	Sales,
	sum(sales) over() TotalSales,
	Round(cast(Sales as float) / sum(sales) over()  * 100,2) PercentageOfTotal  -- in this case the output will be 0 cause the type of data for the Sales is integer and dividing 2 integer columns produces an integer,not a decimal so we have to change the data type of Sales to FLOAT by using CAST Function
from Sales.Orders


--TASK 9: Find the avarage sales across all orders,
--and the avarage sales for each product,
-- Additionally,provide details such as order ID and order Date.

select 
	OrderID,
	ProductID,
	OrderDate,
	Sales,
	avg(sales) over() AvgSales,
	AVG(sales) over(partition by ProductID) AvgSalesByProduct
from Sales.Orders

--TASK 10: find the avarage scors of customers,
-- additionally, provide detials such as Customer ID and Last Name.

select
	CustomerID,
	LastName,
	Score,
	Coalesce(Score,0) CustomerScore,  -- use COALESCE function to convert the NULL value in the score column to 0 cause if we left that as it the AVG will divide by 4 not by 5 so we have to ask first about the meaning of the Null valuses is it empty or 0
	AVG(Score) over() NullAvgScore,
	AVG(Coalesce(Score,0)) over() AvgScoreWithoutNull
from Sales.Customers

--TASK 11: Find all orders where sales are higher than the avarage sales across all orders. 

select 
*
from(
select
OrderID,
ProductID,
Sales,
AVG(Sales) over() AvgSales
from Sales.Orders
)t where Sales > AvgSales



--TASK 12 : Find the highest & lowest sales across all orders,
-- and the highest & lowest sales for each product,
--additionally, provide detais such as order ID and oeder date.

select
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	max(Sales) over() HighestSales,
	min(Sales) over() LowestSales,
	max(Sales) over(partition by ProductID) HighestSalesByProduct,
	min(Sales) over(partition by ProductID) LowestSalesByProduct 
from Sales.Orders

-- TASK 13: Show the Employee with the highest Salaries.

select
*
from(
	select
		EmployeeID,
		FirstName,
		LastName,
		Salary,
		max(Salary) over() HighestSalary
	from Sales.Employees
)t where Salary = HighestSalary


--TASK 14 : find the deviation of each sale from both the minimum and maximum sales amounts.

select
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	max(Sales) over() HighestSales,
	min(Sales) over() LowestSales,
	Sales - min(Sales) over() DeviationFromMin,
	 max(Sales) over() - Sales DeviationFromMax
	from Sales.Orders

--HINT: distance from extreaem: The lower thrdeviation ,the colser the data point is to the extreme


--TASK 15: Calculate the moving average of sales for each product over time
	select 
		OrderID,
		OrderDate,
		ProductID,
		Sales,
		Avg(sales) over(partition by ProductID) AvgByProduct,
		Avg(sales) over(partition by ProductID order by OrderDate)  MovingAvg --mean the sorting of dates is acsending cause we have moving time
	from Sales.Orders

--TASK 16: Calculate the moving average of sales for each product over time,including only the next order.

select 
		OrderID,
		OrderDate,
		ProductID,
		Sales,
		Avg(sales) over(partition by ProductID) AvgByProduct,
		Avg(sales) over(partition by ProductID order by OrderDate)  MovingAvg, --mean the sorting of dates is acsending cause we have moving time
		Avg(sales) over(partition by ProductID order by OrderDate Rows between current row and 1 following  )  RollingAvg
	from Sales.Orders


--RANKING WINDOW FUNCTIONS

-- There are 2 Types of Ranking Window Functions

-- FIRST TYPE : INTEGER-BASED RANKING
-- For Integer -Based Ranking we have 3 functions

--ROW_NUMBER() Function : if two rows shear the same value they will NOT shear the same ranking thats mean each arow has his own Rank.
--RANK() FUNCTION       : if two rows shear the same value they will ACTULLY shear the same ranking but it will keep gaps in the ranking.
--DENSE_RANK() FUNCTION : if two rows shear the same value they will ACTULLY shear the same ranking but it will NOT keep gaps in the ranking.



--TASK1 : Rank the orders based on their sales fron highest to lowest

select
	OrderID,
	ProductID,
	Sales,
	ROW_NUMBER() over(order by sales desc) SealsRank_Row
from Sales.Orders


--TASK 2: Rank the orders based on their sales fron highest to lowest

select
	OrderID,
	ProductID,
	Sales,
	ROW_NUMBER() over(order by sales desc) SealsRank_Row,
	RANK() over(order by sales desc) SealsRank
from Sales.Orders


--TASK 3 : Rank the orders based on their sales fron highest to lowest

select
	OrderID,
	ProductID,
	Sales,
	ROW_NUMBER() over(order by sales desc) SealsRank_Row,
	RANK() over(order by sales desc) SealsRank,
	dense_rank() over(order by sales desc) SealsRank_Dense
from Sales.Orders


-- Use Cases of ROW_NUMBER() function

--USE CASE 1: To find the Top N Analysis

--TASK 4 : Find the top highest sales for each product
select
*
from(
	select
		OrderID,
		ProductID,
		Sales,
		ROW_NUMBER() over(partition by ProductID order by sales desc) RankByProduct
	from Sales.Orders
	)t where RankByProduct =1


--USE CASE 2: To find the Bottom N Analysis

--TASK 5: Find the lowest 2 customers based on their total sales

select 
*
from(
	Select
		CustomerID,
		sum(sales) TotalSales,
		ROW_NUMBER() over(order by sum(sales) asc ) RankCustomer
	from Sales.Orders
	group by CustomerID
	)t where RankCustomer <= 2

-- TASK 6: Assign uniqe IDs to the rows of the 'Orders Archive' table

	select 
	ROW_NUMBER() over(order by OrderID,OrderDate) UniqeID,
	* 
	from Sales.OrdersArchive

--USE CASE 3: To Identify and Removing the Duplicates

--TASK 7: Indentify duplicate rows in the table 'Orders Archive',and return a clean result without any duplicates.

select 
*
from(
	select
		ROW_NUMBER() over(partition by OrderID order by CreationTime desc) rn,  -- we sorting by Creation time cause we have many duplicates and the correct value of the duplicates is the latest time 
		*
	from Sales.OrdersArchive                -- now you can check the duplicate values at rn column if the value > 1
	)t where rn =1 
	-- now it returns the clean data .
	-- if we need to returns the duplicates we can put in the WHERE rn >1

-- SECOND TYPE : PERCENTAGE - BASED RANKING
-- In this type of Ranking we have 2 functions:

-- CUME_DIST() FUNCTION
-- PERCENT_RANK() FUNCTION

--USE CASES : We can use these functions to find the Data Distribution Analysis
 

--TASK 8 : Find the products that fall within the highest 40% of the prices.
select
*,
  CONCAT( DistRank *100 ,'%') DistRankPrecentage
from(
	select 
		Product,
		Price,
		CUME_DIST() over(order by Price desc) DistRank
	from Sales.Products
)t
where  DistRank <= 0.4

-- we can solve the same task with PERCENT_RANK

select
*,
  CONCAT( DistRank *100 ,'%') DistRankPrecentage
from(
	select 
		Product,
		Price,
		percent_rank () over(order by Price desc) DistRank
	from Sales.Products
)t
where  DistRank <= 0.4




--VALUE WINDOW FUNCTIONS 

--THERE ARE 4  VALUE WINDOW FUNCTIONS 
--1- LEAD(_) USE TO ACCESS A VALUE FROM THE NEXT ROW WITHIN A WINDOW
--2-LAG(_) USE TO ACCESS A VALUE FROM THE PREVIOUS NEXT ROW WITHIN A WINDOW
--3- FIRST_VALUE()
--4- LAST_VALUE()


--TASK 1: Analyze month-over-month (MoM) performance by finding the percentage change in sales between the current and previous month

select
*,
CurrentMonthSales - PreviousMonthSales as MoM_Change,
round(cast((CurrentMonthSales - PreviousMonthSales)as float)/PreviousMonthSales *100 , 2 )as   MoM_ChangePrec        -- since we do divition integer by integer so the result will be 0 , to solve this we have to change one of integers to float by using CAST() function 
from(
select 
-- we need to get the just months from the OrderDate so use MONTH() function
MONTH(OrderDate) OrderMonth,
sum(Sales) CurrentMonthSales,
LAG(sum(Sales)) over(order by MONTH(OrderDate)) PreviousMonthSales
from Sales.Orders
group by
MONTH(OrderDate)
)t

--TASK2: In order to analyze customer loyalty,
--rank customers based on the average days between their orders

select 
CustomerID,
AVG(DaysUntilNextOrder) AvgDays,
Rank() over(order by coalesce( AVG(DaysUntilNextOrder),99999)) RankAvg   --we have to replace the null value by high number cause its show now in the first rank and we have to put it at the last rank so use COALESCE() function to change the Null value 
from(
	select 
		OrderID,
		CustomerID,
		OrderDate CurrentOrder,
		LEAD(OrderDate) over(partition by CustomerID order by OrderDate) NextOrder,
		DATEDIFF(day,OrderDate,LEAD(OrderDate) over(partition by CustomerID order by OrderDate)) DaysUntilNextOrder
	from Sales.Orders)t
Group By CustomerID


-- FIRST_VALUE() AND LAST VALUE() Functions 

-- In order to use these functions we have to use FRAME of the window function otherwise it will use the defalt Framing
-- RANG BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW  which is great for using the FIRST_VALUE() function 
--but when we need to use the LAST_VALUE() we have to set up the farme like this 
--RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING


--TASK3: Find the lowest and Highest sales for each product 

select 
	OrderID,
	ProductID,
	Sales,
	FIRST_VALUE(sales) over ( partition by ProductID Order by Sales ) LowestSales,
	LAST_VALUE(sales) over ( partition by ProductID Order by Sales
	ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING ) HighestSales
from sales.orders

-- we can find the Highest seals value without using the LAST_VALUE () function it can be solved just by suing FIRST_VALUE() function
select 
	OrderID,
	ProductID,
	Sales,
	FIRST_VALUE(sales) over ( partition by ProductID Order by Sales ) LowestSales,
	FIRST_VALUE(sales) over ( partition by ProductID Order by Sales desc) HighestSales
from sales.orders

 -- Also we can solve the task just by using MIN() & MAX() Functions
 select 
	OrderID,
	ProductID,
	Sales,
	Min(sales) over ( partition by ProductID  ) LowestSales,
	Max(sales) over ( partition by ProductID ) HighestSales
from sales.orders

--TASK4: Find the lowest and the highest sales for each product,
-- find the differende in sales between the current and the lowest sales.

select 
	OrderID,
	ProductID,
	Sales,
	FIRST_VALUE(sales) over ( partition by ProductID Order by Sales ) LowestSales,
	FIRST_VALUE(sales) over ( partition by ProductID Order by Sales desc) HighestSales,
	Sales - FIRST_VALUE(sales) over ( partition by ProductID Order by Sales) as DifferenceInSales
from sales.orders
