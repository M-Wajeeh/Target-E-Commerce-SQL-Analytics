# 8.Get the % increase in the cost of orders from year 2017 to 2018 (include months between Jan to Aug only).
# You can use the "payment_value" column in the payments table to get the cost of orders.
WITH yearly_total AS(
SELECT
Extract(Year FROM o.order_purchase_timestamp) AS Year,
SUM(p.payment_value) AS total_sales,
FROM `TARGET_DATA.payments` AS p
JOIN `TARGET_DATA.orders` AS o
ON p.order_id=o.order_id
WHERE Extract(Year FROM o.order_purchase_timestamp) IN (2017,2018) AND
  Extract(Month FROM o.order_purchase_timestamp) BETWEEN 1 AND 8
GROUP BY Extract(Year FROM o.order_purchase_timestamp)
),
Yearly_comparison AS(
SELECT 
Year,
total_sales,
LEAD(total_sales) OVER(ORDER BY year DESC) AS Prev_Year_Sales
FROM yearly_total)
SELECT
CONCAT(ROUND(((total_sales - prev_year_sales) / prev_year_sales) * 100 , 2),'%')
FROM Yearly_comparison;

 # 9.Get the MEAN and SUM of Price and Freight value by Customer State
SELECT
  customers.customer_state,
  AVG(order_items.price) AS mean_price,
  SUM(order_items.price) AS sum_price,
  AVG(order_items.freight_value) AS mean_freight_value,
  SUM(order_items.freight_value) AS sum_freight_value
FROM
  `target-sql-analysis-473111`.`TARGET_DATA`.`order_items` AS order_items
INNER JOIN
  `target-sql-analysis-473111`.`TARGET_DATA`.`orders` AS orders
ON
  order_items.order_id = orders.order_id
INNER JOIN
  `target-sql-analysis-473111`.`TARGET_DATA`.`customers` AS customers
ON
  orders.customer_id = customers.customer_id
GROUP BY
  customers.customer_state
ORDER BY
  customers.customer_state;
































































# 10.Calculate the Total & Average value of order freight for each state