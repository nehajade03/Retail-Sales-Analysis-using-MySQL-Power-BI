SELECT * FROM retail_market_analysis.retail_sales_transactions;

SELECT `Invoice ID`, COUNT(*) 
FROM  retail_market_analysis.retail_sales_transactions
GROUP BY `Invoice ID`
HAVING COUNT(*) > 1;


ALTER TABLE retail_market_analysis.retail_sales_transactions
ADD COLUMN Transaction_Date DATE ;

UPDATE retail_market_analysis.retail_sales_transactions
SET Transaction_Date = 
CASE
    WHEN Date LIKE '%/%/%' THEN STR_TO_DATE(Date, '%m/%d/%Y') -- handles 1/27/2019
    WHEN Date LIKE '%-%-%' THEN STR_TO_DATE(Date, '%d-%m-%Y') -- handles 02-10-2019
    ELSE NULL
END;


ALTER TABLE retail_market_analysis.retail_sales_transactions
ADD COLUMN Transaction_time time;

update retail_market_analysis.retail_sales_transactions
SET Transaction_time = STR_TO_DATE(Time, '%H:%i');

select `Customer type`, 
Count(`Invoice ID`) as Transcation_Count
from retail_market_analysis.retail_sales_transactions
group by  `Customer type`;

select `Customer type`,
Round(avg(`Invoice ID`),2) as Avg_Spending
from retail_market_analysis.retail_sales_transactions
group by  `Customer type`;

select Date(Transaction_Date) as Sales_Date,
Round(sum(Total)) as Total_sales
from  retail_market_analysis.retail_sales_transactions
group by
Transaction_Date
Order BY  Sales_Date;

select (Transaction_Date),
Round(sum(Total)) as Total_sales
from retail_market_analysis.retail_sales_transactions
group by Transaction_Date
order by Total_sales Desc
Limit 10;

select
Transaction_Date,
 hour(Transaction_time),
Round(sum(Total)) as Total_sales
from retail_market_analysis.retail_sales_transactions
group by  hour(Transaction_time),Transaction_Date
order by  hour(Transaction_Date) Desc
Limit 10;

-- Product Line Performance:
-- Query to rank product lines by total revenue.

select `Product line`,
Round(Sum(Total),2) as Total_Revenue,
Rank() over (Order by sum(Total) Desc) as Revenue_Rank
From  retail_market_analysis.retail_sales_transactions
Group by `product line`
order by 
Revenue_Rank;

select `Product line`,
Round(avg(Quantity),0) Avg_quantity
from  retail_market_analysis.retail_sales_transactions
Group by `Product line`
order by 
Avg_quantity;

select Payment,
count(Total) as Total_Transcations_count
from retail_market_analysis.retail_sales_transactions
group by Payment 
order by Total_Transcations_count
desc ;

select Payment,
Round(sum(Total),2) as Revenue
from retail_market_analysis.retail_sales_transactions
group by Payment 
order by Revenue
desc ;

select Payment,
round(Avg(Rating),2) as Ratings
from retail_market_analysis.retail_sales_transactions
group by Payment 
order by Ratings
desc ;

-- 4.3 Performance Analysis Using SQL
-- Branch and City-Wise Sales Performance:
-- compare sales revenue across branches and cities.

select Branch,
round(sum(Total),2) as Total_Revenue
from  retail_market_analysis.retail_sales_transactions
group by Branch
order by Total_Revenue;

select City,
round(sum(Total),2) as Total_Revenue
from  retail_market_analysis.retail_sales_transactions
group by City
order by Total_Revenue;

-- 2.Customer Type Revenue Contribution:
-- 	Query to determine whether members or normal customers contribute more to revenue.
select `customer type`,
round(sum(Total),2) as Total_Revenue
from  retail_market_analysis.retail_sales_transactions
group by `customer type`
order by Total_Revenue;

-- 3.Product Line Profitability:
-- 	SQL query to compute the highest profit margins by product category
SELECT 
  `Product line`,
  ROUND(SUM(`Total` - (`Unit price` * `Quantity`)), 2) AS Total_Profit,
  ROUND(SUM(`Total`), 2) AS Total_Revenue,
  ROUND(SUM(`Total` - (`Unit price` * `Quantity`)) / SUM(`Total`) * 100, 2) AS Profit_Margin_Percent
FROM retail_market_analysis.retail_sales_transactions
GROUP BY `Product line`
ORDER BY Profit_Margin_Percent DESC;

SELECT 
ROUND(SUM(`gross income`), 2) AS Total_Gross_Income,
ROUND(SUM(`cogs`), 2) AS Total_COGS,
ROUND((SUM(`gross income`) / (SUM(`cogs`) + SUM(`gross income`))) * 100, 2) 
AS Total_Gross_Margin_Percentage
FROM retail_market_analysis.retail_sales_transactions;


-- 4. Customer Satisfaction Analysis
-- Analyze customer ratings by product line and store branch.
-- Identify factors influencing higher customer satisfaction scores

select `Product line`,
Round(avg(Rating),2) as Avg_Rating
from retail_market_analysis.retail_sales_transactions
group by `Product line`
order by Avg_Rating Desc;

select `Branch`,
Round(avg(Rating),2) as Avg_Rating
from retail_market_analysis.retail_sales_transactions
group by `Branch`
order by Avg_Rating Desc;









