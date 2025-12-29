
/*
=====================product Report===============================
Purpose:
  - This Report shows Key product metrics and behaviors

  Highlights:
 1. Gathers essential fields like product names,Category,subcategory and cost.
 2.segments products by revenue to identify High-perforers,Mid-range or Low-performers.
 3.Aggregates product-level metrics:
         -total orders
         -total sales
         -total quantity sold
         -total customers(unique)
         -lifespan (in months)
 4.Calculates valuable KPIs:
          -recently(months since last sold)
          -average order revenue(AOR)
          -averge monthly revenue
====================================================================
*/  

create view gold.report_products as
--1.base query:retrieve core columns from tables
with base_query as (
select 
f.order_number,
f.order_date,
f.customer_key,
f.sales_amount,
f.quantity,
p.product_key,
p.product_name,
p.category,
p.subcategory,
p.prd_cost from gold.fact_sales f left join
gold.dim_products p 
on p.product_key=f.product_key
where order_date is not null),

products_aggregations as (
 --2.segments products by revenue to identify High-perforers,Mid-range or Low-performers.

 select
 product_key,
 product_name,
 category,
 subcategory,
 prd_cost,
 datediff(month,min(order_date),max(order_date)) as lifespan,
 max(order_date) as last_sales,
 count(distinct order_number) total_orders,
 sum(sales_amount) total_sales,
 count(quantity) total_quantity,
 count(distinct customer_key) total_customers,
 round(avg(cast(sales_amount as float)/nullif(quantity,0)),1) as avg_selling_price
 from base_query
 group by
    product_key,
     product_name,
     category,
     subcategory,
     prd_cost
)

select 
    product_key,
     product_name,
     category,
     subcategory,
     prd_cost,
     last_sales,
     datediff(month,last_sales,getdate()) as recency_in_months,
     case when total_sales>50000 then 'High Performer'
          when total_sales  <=10000 then 'Mid Performer'
          else 'Low Performer'
     end as product_segment,
     lifespan,
     total_orders,
	total_sales,
	total_quantity,
	total_customers,
	avg_selling_price,
    --AOR
    case when total_orders=0 then 0
    else total_sales/total_orders
    end as avg_order_revenue,

    --AMR
    case when lifespan=0 then total_sales
         else total_sales/lifespan
     end as avg_monthly_revenue

from  products_aggregations
