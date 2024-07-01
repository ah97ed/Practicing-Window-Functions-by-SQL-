# SQL Window Functions Practice Project

## Introduction
This repository contains my SQL practice project focused on practicing window functions. The goal of this project is to showcase various SQL window functions and queries used to manipulate and analyze data. The project includes scripts demonstrating:

- Aggregation window functions
- Ranking window functions
- Value window functions

By working through these examples, you can gain a deeper understanding of how window functions can be used to perform advanced data analysis in SQL.

## Data Sources 
SalesDB : The primary dataset used for this analysis is the "SalesDB.bak" file.

## Tools
- SQL Server
  
## Examples

### Find the total sales for each order status , only for two products 101 and 102.

```sql
Select 
ProductID,
Sales,
OrderID,
OrderStatus,
sum(sales) Over(Partition by OrderStatus ) TotalSales
from sales.Orders
where ProductID in (101,102)
```
### Find the percentage contribution of each product's sales to the total sales.
```sql
select 
	OrderID,
	ProductID,
	Sales,
	sum(sales) over() TotalSales,
	Round(cast(Sales as float) / sum(sales) over()  * 100,2) PercentageOfTotal
from Sales.Orders
```
### Find the avarage scors of customers,additionally, provide detials such as Customer ID and Last Name.
```sql
select
	CustomerID,
	LastName,
	Score,
	Coalesce(Score,0) CustomerScore, 
	AVG(Score) over() NullAvgScore,
	AVG(Coalesce(Score,0)) over() AvgScoreWithoutNull
from Sales.Customers
```
### Calculate the moving average and Rolling average of sales for each product over time,including only the next order.

```sql
select 
		OrderID,
		OrderDate,
		ProductID,
		Sales,
		Avg(sales) over(partition by ProductID) AvgByProduct,
		Avg(sales) over(partition by ProductID order by OrderDate)  MovingAvg,
		Avg(sales) over(partition by ProductID order by OrderDate Rows between current row and 1 following ) RollingAvg
	from Sales.Orders
```
###  Analyze month-over-month (MoM) performance by finding the percentage change in sales between the current and previous month.

```sql
select
*,
CurrentMonthSales - PreviousMonthSales as MoM_Change,
round(cast((CurrentMonthSales - PreviousMonthSales)as float)/PreviousMonthSales *100 , 2 )as   MoM_ChangePrec      
from(
select 
MONTH(OrderDate) OrderMonth,
sum(Sales) CurrentMonthSales,
LAG(sum(Sales)) over(order by MONTH(OrderDate)) PreviousMonthSales
from Sales.Orders
group by
MONTH(OrderDate)
)t
```

## Acknowledgements
Thanks to [Data Eith Baraa](https://www.youtube.com/@DataWithBaraa)  for providing the sample datasets and the bralliant free advance SQL Course.
