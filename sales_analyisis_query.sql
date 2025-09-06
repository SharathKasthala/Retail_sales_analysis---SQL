-- SQL RETAIL SALES ANALYSIS --	

-- DATABASE SETUP
	-- creating tables
CREATE TABLE retail_sales
		(
		transactions_id INT PRIMARY KEY,
		sale_date DATE,
		sale_time TIME,
		customer_id	INT,
		gender VARCHAR(10),
		age INT,
		category VARCHAR(20),
		quantiy INT,
		price_per_unit FLOAT,
		cogs	FLOAT,
		total_sale FLOAT
);

alter table retail_sales rename quantiy to quantity
-- Display data
select * from retail_sales


-- Counting Rows
select count(*) from retail_sales

-- DATA CLEANING(checking null values)
select * from retail_sales 
WHERE
	transactions_id IS null
	or 
 	sale_date IS null
 	or
	sale_time IS null
 	or
	customer_id IS null
 	or
	gender IS null
	or
 	category IS null
 	or
	quantity IS null
	or 
	price_per_unit IS null
	or
	cogs IS null
	or
	total_sale IS null


-- DATA CLEANING(Deleting null values)
Delete from retail_sales
WHERE
	transactions_id IS null
	or 
 	sale_date IS null
 	or
	sale_time IS null
 	or
	customer_id IS null
 	or
	gender IS null
	or
 	category IS null
 	or
	quantity IS null
	or 
	price_per_unit IS null
	or
	cogs IS null
	or
	total_sale IS null


-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales

-- How many uniuque customers we have ?
SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales

-- How many unique categories e have?
SELECT DISTINCT category FROM retail_sales


-- Data Analysis

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * from retail_sales 
where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
select * from retail_sales 
where category = 'Clothing' 
and to_char(sale_date,'YYYY-MM') = '2022-11'
and quantity >= 3

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category,
	sum(total_sale) as net_sale,
	count(*) as total_orders
	from retail_sales
	group by 1

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select Round(avg(age)) as Average_age 
from retail_sales 
where category = 'Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales
where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select 
	gender,
	category,
	count(transactions_id) as total_transactions
	from retail_sales
	group by 
		gender,
		category
	order by 1

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT year, month, avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1
    



-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select
	customer_id,
	count(total_sale) as total_sales
	from retail_sales
	group by 1
	order by 2 desc 
	limit 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select
	category,
	sum(distinct customer_id) as total_customers
	from retail_sales
	group by 1

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

With hourly_sale
as
(
select *,
	case 
		When Extract(Hour from sale_time) < 12 Then 'Morning'
		When Extract(Hour from sale_time) between 12 and 17 Then 'Afternoon'
		Else 'Evening'
	End as shift
from retail_sales
)
select 
	shift, 
	count(*) as total_orders
	from hourly_sale
	group by shift
	
