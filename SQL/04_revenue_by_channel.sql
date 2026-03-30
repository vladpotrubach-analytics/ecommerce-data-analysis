-- Revenue and AOV by channel

SELECT
  channel,
  COUNT(*) AS total_orders,
  SUM(total_amount) AS revenue,
  SUM(total_amount) / COUNT(*) AS aov
FROM `ecommerce-portfolio-bq.ecommerce.orders`
WHERE order_status = 'completed'
GROUP BY channel
ORDER BY revenue DESC;
