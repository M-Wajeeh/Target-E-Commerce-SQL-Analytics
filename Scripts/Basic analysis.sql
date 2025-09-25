# import the dataset and do usual exploratory analysis steps like checking the structure & characteristics of the dataset:
# 1. Data type of all columns in the "customers" table.

SELECT * 
FROM `TARGET_DATA.customers`;

SELECT * 
FROM `target-sql-analysis-473111.TARGET_DATA.geolocation`
LIMIT 5;

# 2. Get the time range between which the orders were placed.
SELECT 
MIN(order_purchase_timestamp) AS start_time,
MAX(order_purchase_timestamp) AS end_time
FROM `target-sql-analysis-473111.TARGET_DATA.orders`;

# 3. Count the Cities & States of customers who ordered during the Period.
SELECT 

  COUNT(C.customer_city) AS Total_Cities,
  COUNT(C.customer_state) AS Total_states

FROM `target-sql-analysis-473111.TARGET_DATA.customers` AS C

JOIN `TARGET_DATA.orders` O
  ON C.customer_id=O.customer_id

WHERE O.order_purchase_timestamp 
  BETWEEN(

    SELECT MIN(order_purchase_timestamp) FROM `TARGET_DATA.orders`)
  AND

    ( SELECT MAX(order_purchase_timestamp) FROM `TARGET_DATA.orders`);

# 4.Is there a growing trend in the no. of orders placed over the past years?
SELECT 
Extract(Month FROM order_purchase_timestamp) AS Months,
COUNT(Order_id) AS Total_Orders
FROM `target-sql-analysis-473111.TARGET_DATA.orders`
GROUP BY Extract(Month FROM order_purchase_timestamp)
ORDER BY COUNT(Order_id) ASC;

#5 During what time of the day, do the Brazilian customers mostly place their orders? (Dawn, Morning, Afternoon or Night)
  # ■ 0-6 hrs : Dawn
  # ■ 7-12 hrs : Mornings
  # ■ 13-18 hrs : Afternoon
  # ■ 19-23 hrs : Night

SELECT 
Extract(Hour FROM order_purchase_timestamp) AS Hours,
COUNT(Order_id) AS Total_Orders,
CASE
  WHEN Extract(Hour FROM order_purchase_timestamp) > 6 THEN 'Dawn'
  WHEN Extract(Hour FROM order_purchase_timestamp) BETWEEN 6 AND 12 THEN 'Morning'
  WHEN Extract(Hour FROM order_purchase_timestamp) BETWEEN 13 AND 18 THEN 'Afternoon'
  ELSE 'Night'
END AS TIME_of_day
FROM `TARGET_DATA.orders`
GROUP BY Hours,Time_of_day
ORDER BY Total_Orders DESC;

#6  Get the month on month no. of orders placed in each state.
SELECT 
  FORMAT_TIMESTAMP('%B %Y', order_purchase_timestamp) AS Year_Month,
  c.customer_state,
  COUNT(*) AS Total_Orders
FROM `target-sql-analysis-473111.TARGET_DATA.orders` AS o
LEFT JOIN `target-sql-analysis-473111.TARGET_DATA.customers` AS c
  ON o.customer_id = c.customer_id
  GROUP BY Year_Month,c.customer_state
  ORDER BY Total_Orders DESC;




















