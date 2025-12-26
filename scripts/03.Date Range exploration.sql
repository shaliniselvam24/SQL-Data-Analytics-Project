/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

--find the date of first and last order
--how many years of sales are available

select min(order_date) firstOrder ,
max(order_date) lastOrder,
datediff(year, min(order_date),max(order_date) )
from gold.fact_sales

--youngest and oldest customer
select min(birthdate) oldest,
datediff(year,min(birthdate),getdate()) oldest_age,
datediff(year,max(birthdate),getdate()) youngest_age,
max(birthdate) youngest
from gold.dim_customers
