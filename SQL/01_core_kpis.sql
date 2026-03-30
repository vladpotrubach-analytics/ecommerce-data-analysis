-- Core business metrics: revenue, orders, AOV, unique buyers

SELECT
  COUNT(DISTINCT user_id) AS unique_buyers,
  COUNT(*) AS total_orders,
  SUM(total_amount) AS total_revenue,
  SUM(total_amount) / COUNT(*) AS aov
FROM `ecommerce-portfolio-bq.ecommerce.orders`
WHERE order_status = 'completed';
