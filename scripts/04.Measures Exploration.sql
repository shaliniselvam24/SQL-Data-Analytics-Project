/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/
 
--generate a report that shows all key metrics of the buisness

select 'Total_sales' as measure_name,sum(sales_amount) as measure_value from gold.fact_sales
union all
select 'No_Of_Items' as measure_name,sum(quantity) as measure_value from gold.fact_sales
union all
select 'avg_price' as measure_name,avg(price) as measure_value from gold.fact_sales
union all
select 'NO_Of_Orders' as measure_name,count(distinct order_number) as measure_value from gold.fact_sales
union all
select 'NO_Of_producs' as measure_name,count(product_id) as measure_value from gold.dim_products
union all
select 'NO_Of_customers' as measure_name, count(customer_id) as measure_value from gold.dim_customers
union all
select 'total_NO_Of_customers' as measure_name,count(distinct customer_key) as measure_value from gold.fact_sales
=============================================================================================
--find total sales
select sum(sales_amount) Total_sales
from gold.fact_sales

--how many items are sold
select sum(quantity) No_Of_Items
from gold.fact_sales

--find average selling p rice
select avg(price) avg_price
from gold.fact_sales

--find total no of orders
select
count(distinct order_number) as NO_Of_Orders
from gold.fact_sales

--find total no of products
select count(product_id) as NO_Of_producs
from gold.dim_products

--find total no of customers
select count(customer_id) as NO_Of_customers
from gold.dim_customers

--find total no of customers that has placed orders
select count(distinct customer_key) no_of_cust
from gold.fact_sales

select  count(customer_id) as NO_Of_customers,
count(p.product_id) as NO_Of_products,
sum(sales_amount) Total_sales,
 sum(quantity) No_Of_Items,
 avg(price) avg_price,
 count(distinct order_number) as NO_Of_Orders,
 count(distinct c.customer_key) no_of_cust
 from gold.fact_sales f
 join gold.dim_customers c
 on f.customer_key=c.customer_key
 join gold.dim_products p
 on c.customer_key=p.product_key

 
