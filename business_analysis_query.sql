# SQL retail sales analysis -p1


-- Data Cleaning
SELECT * FROM retail_sales
WHERE transactions_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE sale_time IS NULL

SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- 
DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    

#now the data is imported it is important to check if all the data is imported accurately or not 

select count(*) from retail_sales;

#data exploration

#1. how many unique customers we have?
select count(distinct customer_id) as total_customers from retail_sales;

# all the categories that the business has
select distinct category from retail_sales;

#business key problems

#1. write a sql query to retrieve all columns for sales made on "2022-11-05"

select * from retail_sales
where sale_date = "2022-11-05";

#2. write a sql query to retrieve all transactions where the category is "clothing" and the quantity sold is more than 10 in the month of nov-2022


select * from retail_sales
where category = "Clothing"
	and quantiy >= 4
    and sale_date >= "2022-11-01"
    and sale_date < "2022-12-01";


#3 write a sql query to calculate the total sales (total_sales) fro each category.

select category, sum(total_sale) as total_sales, count(*) as total_orders
from retail_sales
group by category;

#4. write a sql query to find the average age of customers who purchased items from the "Beauty" category

select category, avg(age)
from retail_sales
where category = "Beauty"
group by category;

#5 write a sql query to find all transactions where the total_sales is greater than 1000

select * from retail_sales
where total_sale > 1000;

#6 write a sql query to find the total number of transactions (transaction_id) made be each gender in each category

select gender, category, count(transactions_id) as no_of_transactions 
from retail_sales
group by gender, category;

#7 write a sql query to calcualte the average sale for each month. FInd out best selling month in each year/

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

#8. write a sql query to find the top 5 customers based on the highest sales

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

#some additional questions 
## basic 
#1. Find the total revenue generated across all transactions.

select sum(total_sale) as total_sum_sale
from retail_sales;

#2. Find the number of transactions for each product category.

select category, count(transactions_id) as num_of_transactions
from retail_sales
group by category;


#3. Calculate the average sale value per transaction.

select * from retail_sales;

select avg(total_sale) as avg_transaction_value
from retail_sales ;

## intermediate level questions
#1. Calculate the total sales for each month in the year 2022.

select year(sale_date) as year,
	month(sale_date) as month,
    sum(total_sale) as monthly_sales
from retail_sales
where year(sale_date) = "2022"
group by 1, 2
order by 1, 2 ;

## 2. Calculate the total profit for each category, where
#profit = total_sale − cogs.

select category, (sum(total_sale) - sum(cogs)) as profit
from retail_sales
group by category;


## 3. Identify the top 5 customers based on their total purchase value.

select customer_id, sum(total_sale) as total_sales from retail_sales
group by customer_id
order by sum(total_sale) desc
limit 5;

#advace level question

## 1. Rank all customers based on their total sales, from highest to lowest.

select customer_id, total_sales, rank() over(order by total_sales desc) as sales_rank 
from (
	select customer_id, sum(total_sale) as total_sales from retail_sales
	group by customer_id
) t;

#2. For each product category, identify the month with the highest total sales.

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

#3 Calculate the month-over-month change in total sales across the dataset.

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

## 4. month over month percentage change

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


