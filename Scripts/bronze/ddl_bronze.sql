/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/
create table if not exists crm_cust_info(
		cst_id int,
		cst_key varchar(50),
		cst_firstname varchar(50),
		cst_lastname varchar(50),
		cst_marital_status varchar(50),
		cst_gndr varchar(50),
		cst_create_date date
	);

	create table if not exists crm_prod_info(
		prd_id int,
		prd_key varchar(50),
		prd_nm varchar(50),
		prd_cost int,
		prd_line varchar(50),
		prd_start_dt date,
		prd_end_dt date
	);

	create table if not exists crm_sales_details(
		sls_ord_num varchar(50),
		sls_prd_key varchar(50),
		sls_cust_id int,
		sls_order_dt date,
		sls_ship_dt date,
		sls_due_dt date,
		sls_sales int,
		sls_quantity int,
		sls_price int
	);

	create table if not exists erp_cust_AZ12(
		cid varchar(50),
		bdate date,
		gen varchar(20)
	);

	create table if not exists erp_loc_A101(
		cid varchar(50),
		cntry varchar(50)
	);

	create table  if not exists erp_px_catG1V2(
		id varchar(20),
		cat varchar(50),
		subcat varchar(50),
		maintenance varchar(20)
	);
