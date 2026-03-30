-- Repeat purchase rate: users with 2+ completed orders

WITH user_orders AS (
  SELECT
    user_id,
    COUNT(*) AS order_count
  FROM `ecommerce-portfolio-bq.ecommerce.orders`
  WHERE order_status = 'completed'
  GROUP BY user_id
)

SELECT
  COUNTIF(order_count >= 2) AS repeat_users,
  COUNT(*) AS total_users,
  COUNTIF(order_count >= 2) / COUNT(*) AS repeat_rate
FROM user_orders;
