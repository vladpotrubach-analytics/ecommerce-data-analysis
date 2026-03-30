-- First completed order date for each user

SELECT
  user_id,
  MIN(order_date) AS first_order_date
FROM `ecommerce-portfolio-bq.ecommerce.orders`
WHERE order_status = 'completed'
GROUP BY user_id;
