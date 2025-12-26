/*
=====================Customer Report===============================
Purpose:
  - This Report shows Key Customer metrics and behaviors

  Highlights:
 1. Gathers essential fields like names,ages and transaction details.
 2.segments customers into categories (VIP,Regular,New) and age groups.
 3.Aggregates customer-level metrics:
         -total orders
         -total sales
         -total quantity purchased
         -total products
         -lifespan (in months)
 4.Calculates valuable KPIs:
          -recently(months since last order)
          -average order value
          -averge monthly spend
====================================================================
*/     

create view gold.report_customers as
with base_query as (
--1.Base Query: Retrieves core columns from tables

select 
f.order_number,
f.product_key,
f.order_date,
f.sales_amount,
f.quantity,
c.customer_key,
c.customer_number,
CONCAT(c.first_name,' ',c.last_name) as Customer_name,
datediff(year,c.birthdate,getdate()) as Age 
from gold.fact_sales f 
left join gold.dim_customers c
on f.customer_key= f.customer_key
where order_date is not null),

customer_aggregations as (
 --2.segments customers into categories (VIP,Regular,New) and age groups.

select 
    customer_key,
    customer_number,
    Customer_name,
    Age,
    count(distinct order_number) as total_orders,
    sum(sales_amount) as total_sales,
    sum(quantity) as total_quantity,
    count(distinct product_key) as total_products,
    max(order_date) as Last_order,
    datediff(month,min(order_date),max(order_date)) as lifespan
from base_query
group by 
    customer_key,
    customer_number,
    Customer_name,
    Age)

select 
    customer_key,
    customer_number,
    Customer_name,
    Age,
    case when age<20 then 'Under 20'
         when age between 20 and 29  then 'Under 20-29'
         when age between 30 and 39  then 'Under 30-39'
         when age between 40 and 49  then 'Under 40-49'
         else '50 and above'
     end as age_group,
    case when lifespan >=12 and total_sales>5000 then 'VIP'
         when lifespan >=12 and total_sales<=5000 then 'Regular'
         else 'New'
    end as customer_segment,
     Last_order,
     Datediff(month,  Last_order,getdate()) as recency,
    total_orders,
    total_sales,
    total_quantity,
    total_products
    lifespan,
    --compute avg order value (AVO)
    case when total_orders=0 then 0
         else  total_sales/total_orders
    end as avg_order_value,
    --compute avg monthly spend
    case when lifespan=0 then total_sales
         else  total_sales/lifespan
    end as monthly_spend
    from customer_aggregations
