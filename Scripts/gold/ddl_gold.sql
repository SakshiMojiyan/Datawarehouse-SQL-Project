/*
======================================================
  DDL script : Create Gold views
======================================================
Script Purpose:
          This script creates biews for gold layer in the data warehouse.The gold layer represents final dimension and fact tables(Star schema).
          Each view performs transformations and combines data from silver layer to produce a clean, enriched and buisness-ready dataset.
Usuage: These views can be queried directly for analytics and reporting.

======================================================
*/


select 
	ci.cst_id,
	ci.cst_key,
	ci.cst_firstname,
	ci.cst_lastname,
	ci.cst_marital_status,
	ci.cst_gndr,
	ci.cst_create_date,
    ca.bdate,
    ca.gen,
	la.cntry
from silver.crm_cust_info ci
left join silver.erp_cust_az12 ca 
on ca.cid=ci.cst_key
left join silver.erp_loc_a101 la
on la.cid=ci.cst_key;

-- After joining tables check if any duplicates were introduced by join
select cst_id, count(*) from(//write above query inside) t
group by cst_id
having count(*)>1

-- Data Integration
select distinct
	ci.cst_gndr,
    ca.gen,
case when cst_gndr!='n/a' then cst_gndr
	else coalesce(ca.gen,'n/a')
end as new_gen
from silver.crm_cust_info ci
left join silver.erp_cust_az12 ca 
on ca.cid=ci.cst_key
left join silver.erp_loc_a101 la
on la.cid=ci.cst_key
order by 1,2;

======================================================
  --Create Dimension table: dim_customers
======================================================

create or replace view gold.dim_customers as
select 
	row_number() over (order by ci.cst_id) as customer_key,
	ci.cst_id as customer_id,
	ci.cst_key as customer_number,
	ci.cst_firstname as first_name,
	ci.cst_lastname as last_name,
    la.cntry as country,
	ci.cst_marital_status as marital_status, 
	case when cst_gndr!='n/a' then cst_gndr
		else coalesce(ca.gen,'n/a')
	end as gender,
    ca.bdate as birthdate,
	ci.cst_create_date as create_date 
from silver.crm_cust_info ci
left join silver.erp_cust_az12 ca 
on ca.cid=ci.cst_key
left join silver.erp_loc_a101 la
on la.cid=ci.cst_key;

======================================================
  --Create Dimension table: dim_products
======================================================

create or replace view gold.dim_products as
select
	row_number() over (order by pn.prd_start_dt,pn.prd_key) as product_key,
	pn.prd_id as product_id,
    pn.prd_key as product_number,
    pn.prd_nm as product_name ,
    pn.cat_id as category_id,
    pc.cat as category,
    pc.subcat as subcategory,
    pc.maintenance,
    pn.prd_cost as cost,
    pn.prd_line as product_line,
    pn.prd_start_dt as start_date
from silver.crm_prod_info pn
left join silver.erp_px_catg1v2 pc
on pn.cat_id = pc.id
where prd_end_dt is null -- Filter out all historical data;



======================================================
  --Create Fact table: fact_sales
======================================================
create or replace view gold.fact_sales as
SELECT 
    sd.sls_ord_num as order_number,
    pr.product_key,
    cst.customer_key,
    sd.sls_order_dt as order_date,
    sd.sls_ship_dt as shipping_date,
    sd.sls_due_dt as due_date,
    sd.sls_sales as sales_amount,
    sd.sls_quantity as quantity,
    sd.sls_price as price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr 
ON sd.sls_prd_key = pr.product_number
left join gold.dim_customers cst
on sd.sls_cust_id = cst.customer_id
