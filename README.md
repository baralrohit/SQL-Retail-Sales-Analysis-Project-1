# SQL-Retail-Sales-Analysis-Project-1
This project focuses on performing end-to-end sales analysis using MySQL on a retail transactions dataset. The goal is to extract business insights related to revenue, customer behavior, category performance, and time-based sales trends using SQL queries ranging from basic to advanced.

The project covers:

## Database setup

Data exploration and validation

Business problem solving using SQL

Advanced analytical queries using window functions and CTEs

## Objectives

- Design and create a structured retail sales database
- Perform exploratory data analysis (EDA)
- Answer business-driven questions using SQL
- Apply aggregate functions, CTEs, and window functions
- Analyze customer rankings and month-over-month sales growth

## 1. Database Setup
### Database Creation

```sql
CREATE DATABASE sql_sales_project;
USE sql_sales_project;
```

### Table Creation
``` sql 
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
```
## 2. Data Exploraion

- Record Count: Determine the total number of records in the dataset.
- Customer Count: Find out how many unique customers are in the dataset.
- Category Count: Identify all unique product categories in the dataset.
- Null Value Check: Check for any null values in the dataset and delete records with missing data.

``` sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

## 3. Business Analysis Queries

### 1. write a sql query to retrieve all columns for sales made on "2022-11-05"

``` sql
select * from retail_sales
where sale_date = "2022-11-05";
```

### 2. write a sql query to retrieve all transactions where the category is "clothing" and the quantity sold is more than 10 in the month of nov-2022

``` sql
select * from retail_sales
where category = "Clothing"
	and quantiy >= 4
    and sale_date >= "2022-11-01"
    and sale_date < "2022-12-01";
```

### 3 write a sql query to calculate the total sales (total_sales) fro each category.

``` sql
select category, sum(total_sale) as total_sales, count(*) as total_orders
from retail_sales
group by category;
```

### 4. write a sql query to find the average age of customers who purchased items from the "Beauty" category

``` sql
select category, avg(age)
from retail_sales
where category = "Beauty"
group by category;
```

### 5 write a sql query to find all transactions where the total_sales is greater than 1000

``` sql
select * from retail_sales
where total_sale > 1000;
```

### 6 write a sql query to find the total number of transactions (transaction_id) made be each gender in each category

``` sql
select gender, category, count(transactions_id) as no_of_transactions 
from retail_sales
group by gender, category;
```

### 7 write a sql query to calcualte the average sale for each month. FInd out best selling month in each year/

``` sql
SELECT
    year,
    month,
    avg_monthly_sales
FROM (
    SELECT
        year,
        month,
        avg_monthly_sales,
        RANK() OVER (
            PARTITION BY year
            ORDER BY avg_monthly_sales DESC
        ) AS sales_rank
    FROM (
        SELECT
            YEAR(sale_date) AS year,
            MONTH(sale_date) AS month,
            ROUND(AVG(total_sale), 2) AS avg_monthly_sales
        FROM retail_sales
        GROUP BY YEAR(sale_date), MONTH(sale_date)
    ) t1
) t2
WHERE sales_rank = 1;
```

### 8. write a sql query to find the top 5 customers based on the highest sales

``` sql
select 
	customer_id, 
	total_sales, 
    rank() over(order by total_sales desc) as rank_customers
from (
	select 
		customer_id, 
		sum(total_sale) as total_sales
	from retail_sales
	group by customer_id
    limit 5
) t;
```

### 9. Calculate the total sales for each month in the year 2022.

``` sql
select year(sale_date) as year,
	month(sale_date) as month,
    sum(total_sale) as monthly_sales
from retail_sales
where year(sale_date) = "2022"
group by 1, 2
order by 1, 2 ;
```

### 10. Calculate the total profit for each category.

``` sql
select category, (sum(total_sale) - sum(cogs)) as profit
from retail_sales
group by category;
```

### 11. Rank all customers based on their total sales, from highest to lowest.

``` sql
select customer_id, total_sales, rank() over(order by total_sales desc) as sales_rank 
from (
	select customer_id, sum(total_sale) as total_sales from retail_sales
	group by customer_id
) t;
```

### 12. For each product category, identify the month with the highest total sales.

``` sql
with category_sales as (
	select category, month(sale_date) as month, sum(total_sale) as total_sales
	from retail_sales
	group by 1,2
),
ranked_sales as (
	select category, month, total_sales,
	rank() over(partition by category order by total_sales desc) rank_by_category
	from category_sales
)
select category, month, total_sales
from ranked_sales
where rank_by_category = 1
order by category;
```

### 13. Calculate the month-over-month change in total sales across the dataset.

``` sql
with monthly_sales as (
	select year(sale_date) as year, month(sale_date) as month , sum(total_sale) as total_sales
	from retail_sales
	group by 1, 2
)
select 
	year,
    month,
    total_sales,
    lag(total_sales) over(order by year, month) as previous_month_sales,
    total_sales - lag(total_sales) over ( order by year, month) as mom_change
from monthly_sales
order by year, month;
```

### 14. month over month percentage change

``` sql
WITH monthly_sales AS (
    SELECT
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        SUM(total_sale) AS total_sales
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
)
SELECT
    year,
    month,
    total_sales,
    ROUND(
        (total_sales - LAG(total_sales) OVER (ORDER BY year, month))
        / LAG(total_sales) OVER (ORDER BY year, month) * 100,
        2
    ) AS mom_percentage_change
FROM monthly_sales
ORDER BY year, month;
```

## 3. Findings

- Customer Demographics: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- High-Value Transactions: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- Sales Trends: Monthly analysis shows variations in sales, helping identify peak seasons.
- Customer Insights: The analysis identifies the top-spending customers and the most popular product categories.

## 4. Reports
- Sales Summary: A detailed report summarizing total sales, customer demographics, and category performance.
- Trend Analysis: Insights into sales trends across different months and shifts.
- Customer Insights: Reports on top customers and unique customer counts per category.

## 5. Conclusion
This project provides a comprehensive, end-to-end demonstration of SQL capabilities required for a Data Analyst role. Starting from database creation and data exploration, the analysis progresses through increasingly complex business questions, culminating in advanced time-series and ranking analysis using CTEs and window functions.

Through this project, key business insights were derived regarding customer behavior, sales performance, seasonal trends, and product category effectiveness. The analysis highlights how structured SQL queries can transform raw transactional data into actionable insights that support strategic decision-making.

Overall, this project showcases practical SQL proficiency, analytical thinking, and business understanding, making it a strong portfolio piece for aspiring data analysts and an effective foundation for more advanced analytics and visualization projects in the future.

## 6. How to Use

- Clone the Repository: Clone this project repository from GitHub.
- Set Up the Database: Run the SQL scripts provided in the database_setup.sql file to create and populate the database.
- Run the Queries: Use the SQL queries provided in the business_analysis_queries.sql file to perform your analysis.
- Explore and Modify: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.

## 7. Author

**Rohit Baral**/
**Master’s in Data Science**/
**Aspiring Data Analyst**
