CREATE DATABASE sql_project_1;

DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
			(
				transactions_id INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id INT,
				gender VARCHAR(15),
				age INT,
				category VARCHAR(15),
				quantiy INT,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT
			);
ALTER TABLE retail_sales
CHANGE quantiy quantity INT;

-- DATA CLEANING
SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
    OR
    sale_date IS NULL
    OR
    sale_time IS NULL
    OR
    customer_id IS NULL
    OR
    gender IS NULL
    OR
    age IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    price_per_unit IS NULL
    OR
    cogs IS NULL
    or
    total_sale IS NULL

SELECT 
	COUNT(*)
FROM retail_sales

SET SQL_SAFE_UPDATES = 0;

DELETE FROM retail_sales
WHERE transactions_id IS NULL;
DELETE FROM retail_sales
WHERE sale_date IS NULL;
DELETE FROM retail_sales
WHERE sale_time IS NULL;
DELETE FROM retail_sales
WHERE customer_id IS NULL;
DELETE FROM retail_sales
WHERE gender IS NULL;
DELETE FROM retail_sales
WHERE age IS NULL;
DELETE FROM retail_sales
WHERE category IS NULL;
DELETE FROM retail_sales
WHERE quantity IS NULL;
DELETE FROM retail_sales
WHERE price_per_unit IS NULL;
DELETE FROM retail_sales
WHERE cogs IS NULL;
DELETE FROM retail_sales
WHERE total_sale IS NULL;

SET SQL_SAFE_UPDATES = 1;

-- DATA EXPLORATION

-- How many sales do we have?
SELECT COUNT(*) AS total_sale FROM retail_sales

-- How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) AS total_sale FROM retail_sales

-- Which categories do we have?
SELECT DISTINCT category AS total_sale FROM retail_sales

-- Write a SQL query to retreive all columns for sale made on 2022-11-05
SELECT * 
FROM retail_sales 
WHERE sale_date = '2022-11-05';

-- Write a SQL query to retreive all transactions where category is 'Clothing' and the quantity sold is more than or equal to 4 in the month of Nov-2022
SELECT 
	category,
    SUM(quantity)
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND quantity >= 4
    AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
GROUP BY 1;

-- Write a SQL query to calculate total_sale for each category
SELECT 
	category,
    SUM(total_sale) as net_sale,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY 1;

-- Write a SQL query to find the avg age of customers who purchased items from the 'Beauty' category.

SELECT
	category,
    round(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty'
group by 1;

-- Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales
WHERE total_sale > 1000

-- Write a SQL query to find the total number of transactions(transaction_id) made by each gender in each category

SELECT
	category,
    gender,
    COUNT(*) as total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY 1;

-- Write a SQL query to calculate avg sale for each month. Find out best selling month in each year

SELECT
    year,
    month,
    avg_sale
FROM (
    SELECT
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY YEAR(sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rank_in_year
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS ranked_months
WHERE rank_in_year = 1;


-- Write a sql query to find the top 5 customers based on the highest total sales.

SELECT 
	customer_id,
    SUM(total_sale)
FROM retail_sales
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC
LIMIT 5;

-- Write a SQL query to find the number of unique customers who purchased items from each category

SELECT 
	category,
    COUNT(DISTINCT customer_id) AS cnt_unique_customer
FROM retail_sales
GROUP BY category

-- Write a SQL query to create each shift and number of orders (Example: Morning<=12 , Afternoon b/w 12 & 17 , Evening > 17	)

WITH hourly_sale AS
(
SELECT *,
	CASE
		WHEN HOUR(sale_time) < 12 THEN 'Morning'
		WHEN HOUR(sale_time) >12 and HOUR(sale_time) <17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift
FROM retail_sales
)
SELECT
	shift,
    COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift

-- END OF PROJECT
