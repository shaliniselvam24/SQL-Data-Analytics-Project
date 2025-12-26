/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/
--analyze sales performance over time

select year(order_date) as order_year,
month(order_date) as order_month, 
sum(sales_amount) as total_sales,
count(customer_key) as total_customer
from gold.fact_sales 
where order_date is not null
group by  year(order_date),month(order_date)
order by year(order_date),month(order_date);

--datetrunc()
select datetrunc(year,order_date) as order_year,
sum(sales_amount) as total_sales,
count(customer_key) as total_customer
from gold.fact_sales 
where order_date is not null
group by  datetrunc(year,order_date)
order by  datetrunc(year,order_date)

select datetrunc(month,order_date) as order_year,
sum(sales_amount) as total_sales,
count(customer_key) as total_customer
from gold.fact_sales 
where order_date is not null
group by  datetrunc(month,order_date)
order by  datetrunc(month,order_date)
