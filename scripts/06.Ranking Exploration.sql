/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/
--5 products generate highest revenue

select top 5 
p.product_name ,
sum(f.sales_amount) total_revenue
from gold.fact_sales f
left join gold.dim_products p
on p.product_key=f.product_key
group by p.product_name
order by total_revenue desc

select * from (
select 
p.product_name ,
sum(f.sales_amount) total_revenue,
row_number() over(order by sum(f.sales_amount) desc)as rank_products
from gold.fact_sales f
left join gold.dim_products p
on p.product_key=f.product_key
group by p.product_name)t
where rank_products<=5


--5 worst-performing products in terms of sales

select top 5 
p.product_name ,
sum(f.sales_amount) total_revenue
from gold.fact_sales f
left join gold.dim_products p
on p.product_key=f.product_key
group by p.product_name
order by total_revenue asc

--top 10 cust with highest rev

select * from (
select c.first_name,c.last_name ,
sum(f.sales_amount) TotalRev,
row_number() over(order by sum(f.sales_amount) desc) highRank
from gold.dim_customers c
left join gold.fact_sales f
on c.customer_key=f.customer_key
group by  c.first_name,c.last_name)t
where highRank <=10

--top 3 cust with fewer orders placed 
select top 3 c.customer_key,c.first_name,
c.last_name ,count( distinct order_number) total_orders
from gold.fact_sales f 
left join gold.dim_customers c 
on c.customer_key = f.customer_key
group by c.customer_key,c.first_name,
c.last_name
order by total_orders



select customer_key,
       first_name,
       last_name,
       totalorder from (
select c.customer_key,
c.first_name,c.last_name,
count(distinct f.order_number) TotalOrder,
dense_rank()
over(order by count(distinct f.order_number) asc) noOfOrders
from gold.dim_customers c
left join gold.fact_sales f
on c.customer_key = f.customer_key
group by c.customer_key,
c.first_name,c.last_name)t
where noOfOrders <=3
