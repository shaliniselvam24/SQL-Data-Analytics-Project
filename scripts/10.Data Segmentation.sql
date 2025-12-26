/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/
/*segamnet products into cost ranges and 
count how many prods fall into each segm*/

with product_segments as (
select product_key,
product_name,
prd_cost,
case when prd_cost<100 then 'Below 100'
	when prd_cost between 100 and 500 then '100-500'
	when  prd_cost between 500 and 1000 then '500-1000'
	else  'above 1000'
end cost_range
from gold.dim_products)

select 
cost_range,
count(product_key) as total_products
from 
product_segments
group by cost_range
order by count(product_key) desc 
/*group customers into three
 -VIP:customers with atleast 12 months of history and spending>5000
 -regular:cust with atleast 12 but spending 5000 or less
 -new: cust with lifespan <12 months
and find total no of cust by each grp.*/

with customer_spending as (select c.customer_key,
sum(f.sales_amount) as total_spending,
 min(order_date) as first_order,
max(order_date) as last_order,
datediff(month, min(order_date),max(order_date)) as lifespan
from gold.fact_sales f
left join gold.dim_customers c
on f.customer_key = c.customer_key
group by c.customer_key)


select  cust_category,
count(customer_key) as total_customers
from(
select
customer_key,
case when lifespan >=12 and total_spending>5000 then 'VIP'
      when lifespan >=12 and total_spending<=5000 then 'Regular'
      else 'New'
end as cust_category
from customer_spending)t
group by 
cust_category
order by total_customers desc
