#database and table setup

create database sql_sales_project;
use sql_sales_project;

#create table

create table retail_sales 
			(
				transactions_id	int primary key,
				sale_date	date,
				sale_time	time,
				customer_id	int,
				gender	varchar(10),
				age int,
				category varchar(15),	
				quantiy	int,
				price_per_unit float,	
				cogs	float,
				total_sale float
			);