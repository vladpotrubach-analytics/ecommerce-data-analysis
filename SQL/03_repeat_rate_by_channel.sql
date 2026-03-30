-- Repeat rate by acquisition channel

WITH user_orders AS (
  SELECT
    u.acquisition_channel,
    o.user_id,
    COUNT(*) AS order_count
  FROM `ecommerce-portfolio-bq.ecommerce.orders` o
  JOIN `ecommerce-portfolio-bq.ecommerce.users` u
    ON o.user_id = u.user_id
  WHERE o.order_status = 'completed'
  GROUP BY u.acquisition_channel, o.user_id
)

SELECT
  acquisition_channel,
  COUNTIF(order_count >= 2) AS repeat_users,
  COUNT(*) AS total_users,
  COUNTIF(order_count >= 2) / COUNT(*) AS repeat_rate
FROM user_orders
GROUP BY acquisition_channel
ORDER BY repeat_rate DESC;
