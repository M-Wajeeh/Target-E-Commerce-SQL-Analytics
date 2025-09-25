# 12.Find the month on month no. of orders placed using different payment types.
SELECT
  payment_type,
  EXTRACT( YEAR FROM order_purchase_timestamp) as year,
  EXTRACT( MONTH FROM order_purchase_timestamp) as month,
  COUNT(DISTINCT o.order_id) as order_count
FROM `TARGET_DATA.orders` as o
INNER JOIN `TARGET_DATA.payments` as p
ON o.order_id = p.order_id
GROUP BY payment_type, year, month
ORDER BY payment_type, year, month;

# 13.Find the no. of orders placed on the basis of the payment installments that have been paid.
SELECT 
payment_installments,
COUNT(DISTINCT order_id) AS Order_id,
FROM `TARGET_DATA.payments`
GROUP BY payment_installments;