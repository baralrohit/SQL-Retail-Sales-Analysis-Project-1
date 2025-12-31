# SQL-Retail-Sales-Analysis-Project-1
This project focuses on performing end-to-end sales analysis using MySQL on a retail transactions dataset. The goal is to extract business insights related to revenue, customer behavior, category performance, and time-based sales trends using SQL queries ranging from basic to advanced.

The project covers:

## Database setup

Data exploration and validation

Business problem solving using SQL

Advanced analytical queries using window functions and CTEs

## Objectives

Design and create a structured retail sales database

Perform exploratory data analysis (EDA)

Answer real business questions using SQL

Apply aggregate functions, joins, CTEs, and window functions

Analyze sales trends, customer rankings, and month-over-month growth

## Database Setup
### Database Creation

create database sql_sales_project;
use sql_sales_project;

### Table Creation

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
